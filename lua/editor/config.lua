local M = {
  _project_config_path = '*.code-workspace',
  _global_config_path = '~/.config/nvim/settings.json',
}

local fsutils = require('utils.fs')

function M.project_config()
  local config = {}
  local settings = {}
  local workspace_cfg_list = vim.fn.glob(M._project_config_path)
  if workspace_cfg_list ~= '' then
    local workspace_cfgs = vim.split(workspace_cfg_list, '\n', { plain = true })
    local workspace_cfg
    for _, v in ipairs(workspace_cfgs) do
      workspace_cfg = v
      break
    end
    if workspace_cfg ~= nil or workspace_cfg ~= '' then
      local json_str = fsutils.read_file(workspace_cfg)
      if json_str ~= '' then
        config = vim.json.decode(json_str)
      end
    end
    if config then
      for k, v in pairs(config) do
        if k == 'settings' then
          settings = v
          break
        end
      end
    end
  end
  return settings
end

function M.global_config()
  local settings = {}
  local vsc_cfg_path = vim.fn.expand(M._global_config_path)
  local json_str = fsutils.read_file(vsc_cfg_path)
  if json_str ~= '' then
    settings = vim.json.decode(json_str)
  end
  if not settings then
    settings = {}
  end
  return settings
end

--- @param key string
--- @param val any
--- @param ignore_pattern_list table
--- @return table|nil
-- This function takes in a key in the JSON config and the associated
-- value and then converts it into a object hierarchy with the value
-- attached to the leaf node
function M.parse_config_item(key, val, ignore_pattern_list)
  local config = {}

  for _, pat in ipairs(ignore_pattern_list) do
    if string.match(key, pat) then
      return nil
    end
  end

  local sub_key_list = vim.split(key, '.', { plain = true })

  config[sub_key_list[#sub_key_list]] = val
  for i = #sub_key_list - 1, 1, -1 do
    local sub_config = {}
    sub_config[sub_key_list[i]] = config
    config = sub_config
  end

  return config
end

function M._parse_config_dict(input_config)
  local parsed_config = {}

  for key, val in pairs(input_config) do
    if type(key) == 'number' --[[ or not string.match(key, "**") ]]
    then
      return nil
    end
    if type(val) == 'table' then
      local new_val = M._parse_config_dict(val)
      if new_val then
        val = new_val
      end
    end
    local config = M.parse_config_item(key, val, { '%*%*' })
    if config then
      parsed_config = vim.tbl_deep_extend('force', parsed_config or {}, config)
    end
  end

  return parsed_config
end

function M.base_config()
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
      autoClosingBrackets = "always", -- always, beforeWhitespace, languageDefined, never
      autoClosingQuotes = "always",   -- always, beforeWhitespace, languageDefined, never
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

  return default_cfg
end

--- @param default_cfg? any
function M.parse_config()
  local default_cfg = M.base_config() or {}
  if not default_cfg then
    default_cfg = {}
  end

  local local_config = M.project_config()
  local global_config = M.global_config()
  local nvim_config = vim.deepcopy(default_cfg)

  if global_config then
    vim.g.raw_global_config = global_config
    local parsed_global_config = M._parse_config_dict(global_config)
    if parsed_global_config then
      nvim_config = vim.tbl_deep_extend('force', nvim_config, parsed_global_config)
    end
  end

  if local_config then
    vim.g.raw_project_config = local_config
    local parsed_local_config = M._parse_config_dict(local_config)
    if parsed_local_config then
      nvim_config = vim.tbl_deep_extend('force', nvim_config, parsed_local_config)
    end
  end

  return nvim_config
end

return M
