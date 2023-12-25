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
    highlightLine = false,
    wordWrap = 'bounded',
    wordWrapColumn = 120,
    autoIndent = 'none',
    rulers = {
      9999,
    },
    suggestOnTriggerCharacters = false,
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
    wordBasedSuggestions = false,
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
      parsed_config.editor.highlightLine = false
      parsed_config.editor.showSignColumn = false
    end
  end
  return parsed_config
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

function M.init(editorconfig, buf_id)
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
    -- "netrw",
    -- "netrwPlugin",
    -- "netrwSettings",
    -- "netrwFileHandlers",
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
  local editorops = require('editor.operations')

  if buf_id and buf_id ~= -1 then
    editoropt.load_buf(editorconfig, buf_id)
  else
    editoropt.load(editorconfig)
  end

  -- Set up document clean up commands based on the project configuration
  vim.api.nvim_create_augroup('GenericPreWriteTasks', { clear = true })
  if editorconfig.files.trimFinalNewlines then
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
      group = 'GenericPreWriteTasks',
      callback = function()
        editorops.trim_final_newlines()
      end,
      desc = 'Remove trailing new lines at the end of the document',
    })
  end
  if editorconfig.files.trimTrailingWhitespace then
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
      group = 'GenericPreWriteTasks',
      callback = function()
        editorops.trim_trailing_whitespace()
      end,
      desc = 'Remove trailing whitespaces',
    })
  end

  -- Add triggers for changing editor options dynamically based on the file type
  vim.api.nvim_create_augroup('FileTypeReloadConfig', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      local cfg = M.ftconfig(ft, true)
      editoropt.load_buf(cfg, bufnr)
      vim.schedule(function()
        require('plugins.lspconfig').setup_lsp(ft, cfg)
      end)
    end,
    group = 'FileTypeReloadConfig',
    desc = 'Reload config based on file type',
  })

  -- Load global keymaps
  require('keymaps.global').setup({ buffer = false })
end

return M
