---@class Editor
local M = {}

local default_cfg = {
  files = {
    exclude = {
      ['**/.cache/**'] = true,
    },
    trimFinalNewlines = false,
    trimTrailingWhitespace = false,
  },
  window = {
    filename = 'base', -- possible values: base, rootrel, absolute
  },
  editor = {
    formatOnPaste = false,
    formatOnSave = false,
    insertSpaces = false,
    tabSize = 8,
    detectIndentation = false,
    cursorSmoothCaretAnimation = false,
    renderWhitespace = 'all',
    lineNumbers = 'relative',
    showPosition = false,
    showSignColumn = true,
    renderLineHighlight = 'none',
    wordWrap = 'bounded',
    wordWrapColumn = 120,
    autoIndent = 'none',
    wordBasedSuggestions = false,
    suggestOnTriggerCharacters = false,
    rulers = {
      9999,
    },
    guides = {
      indentation = false,
      context = false,
      highlightActiveBracketPair = false,
      highlightActiveIndentation = false,
      bracketPairs = false,
      bracketPairsHorizontal = false,
    },
    inlayHints = {
      enabled = 'off',
    },
    quickSuggestions = {
      other = 'off',
      comments = 'off',
      strings = 'off',
    },
    suggest = {
      enabled = false,
      showWords = false,
      showSnippets = true,
      showFiles = true,
      preview = true,
      insertMode = 'replace',
      filterGraceful = false,
    },
  },
}

function M.config(profile)
  local parsed_config = vim.g.config
  if not parsed_config or vim.tbl_isempty(parsed_config) then
    parsed_config = require('editor.vscode').parse_config(default_cfg) or default_cfg
    vim.filetype.add {
      extension = {
        ['code-workspace'] = 'json',
      },
      filename = {
        ['go.mod'] = 'gomod',
      },
    }
    if profile.minimal then
      parsed_config.editor.lineNumbers = 'off'
      parsed_config.editor.showPosition = false
      parsed_config.editor.renderWhitespace = 'none'
      parsed_config.editor.insertSpaces = true
      parsed_config.editor.renderLineHighlight = 'none'
      parsed_config.editor.showSignColumn = false
    end
  end
  return parsed_config
end

function M.reload(profile)
  vim.g.config = {}
  vim.g.buf_config = {}
  local editorconfig = M.config(profile)
  local editoropt = require("editor.options")

  local buf_opts = {}

  if profile and not profile.minimal then
    M._setup_event_listeners()
  end

  editoropt.load(editorconfig, buf_opts)
end

function M.ftconfig(ft, use_default)
  local config = vim.g.ft_config[ft]
  if not config or vim.tbl_isempty(config) then
    local lang_key = '[' .. ft .. ']'
    local lang_config = vim.g.config[lang_key]
    if lang_config then
      local workspace_cfg = vim.deepcopy(vim.g.config)
      config = vim.tbl_deep_extend('force', workspace_cfg, lang_config)
      local new_buf_config = {
        [ft] = config,
      }
      vim.g.ft_config = vim.tbl_deep_extend("force", vim.g.ft_config, new_buf_config)
    else
      if use_default then
        config = vim.g.config
      end
    end
  end
  return config
end

function M._is_formatting_enabled(buf_id)
  local autoformatcmd = vim.api.nvim_get_autocmds({ buffer = buf_id, group = 'LspAutoFormat' })
  local prewritecmd = vim.api.nvim_get_autocmds({ buffer = buf_id, group = 'GenericPreWriteTasks' })
  if (autoformatcmd and #autoformatcmd <= 0) and (prewritecmd and #prewritecmd <= 0) then
    return false
  end
  return true
end

function M._setup_event_listeners()
  vim.api.nvim_create_augroup('FileTypeReloadConfig', { clear = true })
  vim.api.nvim_create_augroup('GenericPreWriteTasks', { clear = true })

  -- Add triggers for dynamic configuration based on the buffer
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = 'FileTypeReloadConfig',
    callback = function(args)
      local bufnr = args.buf
      local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
      if not require('editor.utils').is_buf_valid(bufnr) then
        return
      end
      local cfg = M.ftconfig(ft, true)
      require("editor.options").load(cfg, { buf_id = bufnr })
      vim.schedule(function()
        require('plugins.lspconfig').setup_lsp(ft, cfg)
      end)
      vim.schedule(function()
        require('plugins.ibl').setup_buffer(bufnr, cfg)
      end)
      if not M._is_formatting_enabled(bufnr) then
        -- Set up document clean up commands based on the project configuration
        if cfg.files.trimFinalNewlines then
          vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
            group = 'GenericPreWriteTasks',
            callback = function()
              if not require('editor.utils').is_buf_valid(bufnr) then
                return
              end
              require('editor.operations').trim_final_newlines(bufnr)
            end,
            buffer = bufnr,
            desc = 'Remove trailing new lines at the end of the document',
          })
        end
        if cfg.files.trimTrailingWhitespace then
          vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
            group = 'GenericPreWriteTasks',
            callback = function()
              if not require('editor.utils').is_buf_valid(bufnr) then
                return
              end
              require('editor.operations').trim_trailing_whitespace(bufnr)
            end,
            buffer = bufnr,
            desc = 'Remove trailing whitespaces',
          })
        end
      end
    end,
    desc = 'Reload config based on file type',
  })
end

function M.init(profile, editorconfig, buf_id)
  if not editorconfig then
    return
  end

  -- Disable some builtin vim plugins
  local default_plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "tutor",
    "rplugin",
    "syntax",
    "synmenu",
    "optwin",
    "compiler",
    "bugreport",
    "ftplugin",
    -- "netrw",
    -- "netrwPlugin",
    -- "netrwSettings",
    -- "netrwFileHandlers",
  }

  for _, plugin in pairs(default_plugins) do
    vim.g["loaded_" .. plugin] = 1
  end

  -- Disable some builtin providers
  local default_providers = {
    "node",
    "perl",
    "python3",
    "ruby",
  }

  for _, provider in ipairs(default_providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
  end

  local editoropt = require("editor.options")
  local editorutil = require('editor.utils')

  local buf_opts = {}

  if buf_id and buf_id ~= -1 then
    buf_opts.buf_id = buf_id
    if not editorutil.is_buf_valid(buf_id) then
      return
    end
  end

  if profile and not profile.minimal then
    M._setup_event_listeners()
  end

  editoropt.load(editorconfig, buf_opts)

  -- Load global keymaps
  require('keymaps.global').setup({ buffer = false })
end

return M
