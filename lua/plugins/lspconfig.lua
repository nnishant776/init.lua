local spec = {
  enabled = true,
  cond = true,
  dependencies = {
    'hrsh7th/nvim-cmp',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'j-hui/fidget.nvim',
    'petertriho/cmp-git',
  },
}

local editor = require('editor')
local fsutils = require("utils.fs")

vim.api.nvim_create_augroup('LspAutoFormat', { clear = true })

local LSP = {}

function LSP.new(server_name, settings, capabilities, launch_cfg)
  return setmetatable({
    done = false,
    name = server_name,
    client = nil,
    settings = settings or {},
    capabilities = capabilities or {},
    launch_cfg = launch_cfg,
  }, {
    __index = LSP,
  })
end

function LSP:default_lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local is_cmp_nvim_lsp_present, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if is_cmp_nvim_lsp_present then
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
  end

  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { 'markdown', 'plaintext' },
    snippetSupport = false,
    preselectSupport = false,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      },
    },
  }

  return capabilities
end

function LSP:setup(opts)
  local is_lsp_present, lsp = pcall(require, 'lspconfig')
  local is_cmp_present, _ = pcall(require, 'cmp')
  if not is_lsp_present or not is_cmp_present then
    return
  end

  opts = opts or {}

  self.capabilities = vim.tbl_deep_extend(
    "force",
    self:default_lsp_capabilities(),
    self.capabilities,
    opts.capabilities or {}
  )

  self.settings = vim.tbl_deep_extend("force", self.settings, opts.settings or {})

  local setup_opts = {
    on_init = function(client, config)
      self:on_init(client, config)
    end,
    on_attach = function(_, buf_id)
      self:on_attach(buf_id)
    end,
    settings = self.settings,
    capabilities = self.capabilities,
  }

  if self.launch_cfg then
    setup_opts = vim.tbl_deep_extend("keep", setup_opts, self.launch_cfg)
  end

  lsp[self.name].setup(setup_opts)
end

function LSP:on_init(client, _)
  self.client = client
  self.done = true
end

function LSP:on_attach(buf_id)
  buf_id = buf_id or 0
  -- Disable semantic tokens
  self.client.server_capabilities.semanticTokensProvider = nil
  vim.api.nvim_clear_autocmds { buffer = buf_id, group = 'LspAutoFormat' }
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = buf_id })
  self:setup_highlight(buf_id)
  self:setup_formatting(buf_id)
  self:setup_keymaps(buf_id)
  self:setup_inlay_hints(buf_id)
end

function LSP:setup_highlight(buf_id)
  buf_id = buf_id or 0
  if self.client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_buf_create_user_command(buf_id, 'LspSetHighlight', function()
      vim.lsp.buf.document_highlight()
    end, {})
    vim.api.nvim_buf_create_user_command(buf_id, 'LspClearHighlight', function()
      vim.lsp.buf.clear_references()
    end, {})
  end
end

function LSP:setup_formatting(buf_id)
  buf_id = buf_id or 0
  local max_buffer_size = 100 * 1024 -- 100KiB

  if self.client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_buf_create_user_command(buf_id, 'LspFormat', function(args)
      local format_args = { bufnr = buf_id, async = false }
      if self.client.server_capabilities.documentRangeFormattingProvider then
        if args.range ~= 0 then
          format_args.range = { ['start'] = { args.line1, 0 }, ['end'] = { args.line2, 0 } }
        end
      end
      vim.lsp.buf.format(format_args)
    end, { range = true, nargs = '*' })

    -- Enable auto formatting only when file size is small
    if not fsutils.is_file_size_big(buf_id, max_buffer_size) then
      vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function()
          local ft = vim.api.nvim_get_option_value('filetype', { buf = buf_id })
          local cfg = editor.ftconfig(ft, true)
          if cfg and cfg.editor.formatOnSave then
            vim.lsp.buf.format { bufnr = buf_id, async = false }
          end
        end,
        buffer = buf_id,
        group = 'LspAutoFormat',
        desc = 'Document Format',
      })
    end
  end
end

function LSP:setup_inlay_hints(buf_id)
  if self.client.server_capabilities.inlayHintProvider then
    if not vim.lsp.inlay_hint.is_enabled(buf_id) then
      local max_buffer_size = 100 * 1024 -- 100KiB
      local ft = vim.api.nvim_get_option_value('filetype', { buf = buf_id })
      local cfg = editor.ftconfig(ft, true)
      local is_file_size_big = fsutils.is_file_size_big(buf_id, max_buffer_size)
      local is_inlay_hints_enabled = cfg.editor.inlayHints.enabled ~= nil and cfg.editor.inlayHints.enabled ~= 'off'
      if not is_file_size_big and is_inlay_hints_enabled then
        vim.lsp.inlay_hint.enable(buf_id, true)
      end
    end
  end
end

function LSP:setup_keymaps(buf_id)
  buf_id = buf_id or 0
  local is_lsp_keymap_present, keymap = pcall(require, 'keymaps.lspconfig')
  if is_lsp_keymap_present then
    keymap.setup({ buffer = buf_id })
  end
end

function LSP:is_setup_done()
  return self.done
end

local filetype_lsp_map = {
  ['c'] = 'clangd',
  ['cpp'] = 'clangd',
  ['python'] = 'pyright',
  ['go'] = 'gopls',
  ['zig'] = 'zls',
  ['rust'] = 'rust_analyzer',
  ['lua'] = 'lua_ls',
}

local lang_server_map = {
  ['clangd'] = LSP.new('clangd', {}, {}, {
    cmd = {
      "clangd",
      "--all-scopes-completion",
      "-j=4",
      "--completion-style=detailed",
      "--cross-file-rename",
      "--header-insertion=iwyu",
      "--enable-config",
      "--malloc-trim",
      "--pretty",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--inlay-hints=true"
    }
  }),
  ['gopls'] = LSP.new('gopls', {
    gopls = {
      experimentalPostfixCompletions = false,
      analyses = {
        shadow = true,
        fieldalignment = true,
        unsed = true,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        unusedvariable = true,
        all = true,
        ST1003 = false,
        ST1006 = false,
        ST1020 = false,
        ST1021 = false,
        ST1022 = false,
        ST1023 = false,
        QF1011 = false,
      },
      staticcheck = true,
      linksInHover = false,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  }, {}),
  ['pyright'] = LSP.new('pyright', {}, {}),
  ['lua_ls'] = LSP.new('lua_ls', {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          [string.format("%s", vim.env.VIMRUNTIME)] = true,
          [vim.fn.expand '$VIMRUNTIME/lua'] = true,
          [vim.fn.expand '$VIMRUNTIME/lua/vim/lsp'] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
      hint = {
        enable = true,
      },
    },
  }, {}),
  ['zls'] = LSP.new('zls', {}, {}),
  ['rust_analyzer'] = LSP.new('rust_analyzer', {}, {}),
}

local M = {}

function M.is_enabled(profile, editorconfig)
  if profile.minimal or profile.default then
    return false
  else
    return editorconfig.editor.suggest.enabled
  end
end

function M.setup(profile, editorconfig)
  spec.cond = M.is_enabled(profile, editorconfig)
  if not spec.cond then
    return
  end
  spec.config = function(_, _)
    local gcfg = editor.config(profile)
    if gcfg.editor.suggest.enabled then
      for ft in pairs(filetype_lsp_map) do
        local cfg = editor.ftconfig(ft, false)
        if cfg and cfg.editor.suggest.enabled then
          M.setup_lsp(ft, cfg)
        end
      end
    end
  end
end

function M.setup_lsp(ft, editorconfig)
  local lang_server = filetype_lsp_map[ft]
  if lang_server then
    if editorconfig.editor.suggest.enabled then
      local ls = lang_server_map[lang_server]
      if ls and not ls:is_setup_done() then
        ls:setup({})
      end
    end
  end
end

function M.spec()
  return spec
end

return M
