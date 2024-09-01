---@class Editor
local M = {}

local default_cfg = {
  files = {
    eol = '\n',
    encoding = 'utf8',
    exclude = {
      ['**/.cache/**'] = true,
    },
    insertFinalNewline = true,
    trimFinalNewlines = false,
    trimTrailingWhitespace = false,
  },
  editor = {
    autoIndent = 'none',
    cursorSmoothCaretAnimation = "on",
    detectIndentation = false,
    formatOnPaste = false,
    formatOnSave = false,
    insertSpaces = true,
    lineNumbers = 'relative',
    occurrencesHighlight = 'off',
    quickSuggestions = {
      other = 'off',
      comments = 'off',
      strings = 'off',
    },
    quickSuggestionsDelay = 500,
    renderLineHighlight = 'none',
    renderWhitespace = 'none',
    rulers = {
      9999,
    },
    selectionHighlight = false,
    showPosition = false,
    showSignColumn = true,
    suggestOnTriggerCharacters = false,
    tabSize = 4,
    wordBasedSuggestions = 'off',
    wordWrap = '',
    wordWrapColumn = 0,
    guides = {
      bracketPairs = false,
      bracketPairsHorizontal = false,
      context = false,
      highlightActiveBracketPair = false,
      highlightActiveIndentation = false,
      indentation = false,
    },
    inlayHints = {
      enabled = 'off',
    },
    hover = {
      enabled = false,
      delay = 500
    },
    semanticHighlighting = {
      enabled = false
    },
    suggest = {
      enabled = false,
      filterGraceful = false,
      insertMode = 'replace',
      localityBonus = false,
      preview = true,
      showWords = false,
      signatureHelp = false,
    },
  },
  window = {
    filename = 'base', -- possible values: base, rootrel, absolute
    cmdHeight = 1,
    hideInvalidBuffers = true,
  },
}

local function startswith(s, prefix)
  local substr = string.sub(s, 1, #prefix)
  return substr == prefix
end

local function extract_lang(key)
  local start_idx = string.find(key, '%[')
  local end_idx = string.find(key, '%]')
  return string.sub(key, start_idx + 1, end_idx - 1)
end

function M.config(profile)
  local parsed_config = vim.g.config
  if not parsed_config or vim.tbl_isempty(parsed_config) then
    parsed_config = require('editor.config').parse_config(default_cfg) or default_cfg
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
    M._setup_event_listeners(editorconfig)
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

function M.bufconfig(buf_id, use_default)
  local ft = vim.api.nvim_get_option_value('filetype', { buf = buf_id })
  return M.ftconfig(ft, use_default)
end

function M._is_formatting_enabled(buf_id)
  local autoformatcmd = vim.api.nvim_get_autocmds({ buffer = buf_id, group = 'LspAutoFormat' })
  local prewritecmd = vim.api.nvim_get_autocmds({ buffer = buf_id, group = 'GenericPreWriteTasks' })
  if (autoformatcmd and #autoformatcmd <= 0) and (prewritecmd and #prewritecmd <= 0) then
    return false
  end
  return true
end

function M._setup_event_listeners(editorconfig)
  vim.api.nvim_create_augroup('FileTypeReloadConfig', { clear = true })
  vim.api.nvim_create_augroup('GenericPreWriteTasks', { clear = true })
  vim.api.nvim_create_augroup('DynamicEditorOptions', { clear = true })
  vim.api.nvim_create_augroup('DynamicEditorHighlights', { clear = true })

  -- Add triggers for dynamic configuration based on the buffer
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = 'FileTypeReloadConfig',
    callback = function(args)
      local bufnr = args.buf
      local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
      if not require('editor.utils').is_buf_valid(bufnr) then
        if editorconfig.window.hideInvalidBuffers then
          vim.api.nvim_set_option_value('buflisted', false, { buf = bufnr })
        end
        return
      end
      vim.b[bufnr].tabpage = vim.api.nvim_get_current_tabpage()
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

  -- Modify options based on editor mode
  vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeave' }, {
    group = 'DynamicEditorOptions',
    callback = function(args)
      local update_time = vim.api.nvim_get_option_value('updatetime', {})
      if args.event == 'InsertEnter' then
        vim.api.nvim_set_option_value('updatetime', update_time / 2, {})
      elseif args.event == 'InsertLeave' then
        vim.api.nvim_set_option_value('updatetime', update_time * 2, {})
      end
    end,
    desc = 'Update editor options dynamically'
  })

  -- Setup dynamic highlights
  if editorconfig.editor.selectionHighlight then
    vim.api.nvim_create_autocmd({ 'CursorHold' }, {
      group = 'DynamicEditorHighlights',
      callback = function(args)
        local sel_match_id = vim.b[args.buf].sel_match_id
        if sel_match_id and sel_match_id ~= -1 then
          vim.fn.matchdelete(sel_match_id)
        end
        vim.b[args.buf].sel_match_id = vim.fn.matchadd('Search', vim.fn.expand('<cword>'))
      end
    })
  end
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

  if (profile and profile.minimal) or not editorconfig.editor.guides.bracketPairs then
    vim.g["loaded_matchparen"] = 1
  end

  -- Disable some builtin providers
  local default_providers = {
    "node",
    "perl",
    "python3",
    "ruby",
  }

  for _, provider in ipairs(default_providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 1
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
    M._setup_event_listeners(editorconfig)
    -- Setup file type specific configuration
    for key in pairs(editorconfig) do
      if startswith(key, '[') then
        local lang_key = extract_lang(key)
        M.ftconfig(lang_key, true)
      end
    end
  end

  editoropt.load(editorconfig, buf_opts)

  -- Load global keymaps
  require('keymaps.global').setup({ buffer = false })

  -- Load global highlights
  local highlights = require('highlight').global({})
  for hl_name, hl_cfg in pairs(highlights) do
    vim.api.nvim_set_hl(0, hl_name, hl_cfg)
  end

  local background = "dark"
  if editorconfig.window.background == "light" then
    background = "light"
  end
  vim.opt.background = background

  -- Setup editor global commands
  M._setup_global_commands()
end

local function convert(v, typ)
  if typ == 'number' or typ == 'integer' or typ == 'float' then
    return tonumber(v)
  elseif typ == 'boolean' then
    if v == "true" then
      return true
    else
      return false
    end
  else
    if v == 'empty' then
      if typ == 'string' then
        v = ''
      elseif typ == 'list' or typ == 'object' then
        v = {}
      end
    elseif v == 'nil' then
      v = nil
    end
    return v
  end
end

function M._setup_global_commands()
  -- Update config command
  -- This command will accept the first argument as the filetype for which the config should be updated.
  -- Pass an empty string to update the global config.
  -- The second argument will be the json key in the setting.json on which the update will be applied
  -- The third argument will be the value itself
  vim.api.nvim_create_user_command(
    "UpdateConfig",
    function(args)
      if #args.fargs < 3 then
        print("invalid arg count", #args.fargs)
        return
      end
      local ft = ""
      if #args.fargs == 4 then
        ft = args.fargs[4]
      end
      local key = args.fargs[1]
      local val = convert(args.fargs[2], args.fargs[3])
      local cfg_patch = require('editor.config').parse_key_val(key, val, { '%*%*' })
      if ft ~= "" then
        local lang_key = '[' .. ft .. ']'
        local lang_cfg = vim.g.config[lang_key]
        lang_cfg = vim.tbl_deep_extend("force", lang_cfg or {}, cfg_patch)
        local global_cfg = vim.g.config
        global_cfg[lang_key] = lang_cfg
        vim.g.config = global_cfg
        local ft_config = vim.g.ft_config
        if ft_config then
          ft_config[ft] = {}
          vim.g.ft_config = ft_config
        end
        M.ftconfig(ft, true)
      else
        vim.g.config = vim.tbl_deep_extend("force", vim.g.config, cfg_patch)
      end
      local profile = require('profiles').init()
      local editorcfg = vim.g.config
      if ft ~= "" then
        editorcfg = M.ftconfig(ft, true)
        M.init(profile, editorcfg, 0)
      else
        M.init(profile, editorcfg)
      end
    end,
    { nargs = '*', force = true }
  )

  -- CloseBuffers - Command to selectively close open buffer
  -- This command will selectively wipe out all the listed buffers
  vim.api.nvim_create_user_command(
    "CloseBuffers",
    function(args)
      local editorutils = require('editor.utils')
      local uiutils = require('utils.ui')
      local buf_list = vim.api.nvim_list_bufs()
      local active_bufs = uiutils.get_visible_bufs()
      local delete_type = 'all'
      if #args.fargs > 0 then
        delete_type = args.fargs[1]
      end
      for _, buf in ipairs(buf_list) do
        if editorutils.is_buf_valid(buf) or editorutils.is_buf_empty(buf) then
          if delete_type == 'all' then
            vim.api.nvim_buf_delete(buf, {})
          elseif delete_type == 'inactive' then
            if not vim.tbl_contains(active_bufs, buf) then
              vim.api.nvim_buf_delete(buf, {})
            end
          elseif delete_type ~= '' and vim.api.nvim_get_option_value('filetype', { buf = buf }) == delete_type then
            vim.api.nvim_buf_delete(buf, {})
          end
        end
      end
    end,
    { nargs = '*' }
  )

  -- Grep
  vim.api.nvim_create_user_command(
    "Grep",
    function(args)
      local is_telescope_found, _ = pcall(require, 'telescope')
      if not is_telescope_found then
        vim.cmd("silent grep " .. args.args .. '| copen')
      else
        vim.cmd("silent grep " .. args.args .. '| Telescope quickfix')
      end
    end,
    { nargs = '*' }
  )
end

return M
