-- parse vscode workspace settings

local default_cfg = {
  files = {
    exclude = {
      ["**/.cache/**"] = true,
    },
    trimFinalNewlines = false,
    trimTrailingWhitespace = false,
  },
  editor = {
    formatOnPaste = false,
    formatOnSave = false,
    insertSpaces = false,
    tabSize = 8,
    detectIndentation = false,
    renderWhitespace = "all",
    lineNumbers = "relative",
    rulers = {
      9999,
    },
    guides = {
      indentation = false,
      highlightActiveBracketPair = false,
      highlightActiveIndentation = false,
      bracketPairs = false,
      bracketPairsHorizontal = false,
    },
    inlayHints = {
      enabled = "off",
    },
    wordBasedSuggestions = false,
    quickSuggestions = {
      other = "off",
      comments = "off",
      strings = "off",
    },
    suggest = {
      enabled = false,
      showWords = false,
      showSnippets = true,
      showFiles = true,
      preview = true,
      insertMode = "replace",
      filterGraceful = false,
    },
  }
}

local read_file = function(filename)
  local file = io.open(filename, "r")
  if file ~= nil then
    return file:read("*a")
  else
    return ""
  end
end


local read_vsc_cfg_local = function()
  local config = nil
  local settings = nil
  local workspace_cfg_list = vim.fn.glob("*.code-workspace")
  if workspace_cfg_list ~= "" then
    local workspace_cfg = vim.split(workspace_cfg_list, "\n", true)
    for _, v in ipairs(workspace_cfg) do
      workspace_cfg = v
      break
    end
    if workspace_cfg ~= nil or workspace_cfg ~= "" then
      local json_str = read_file(workspace_cfg)
      if json_str ~= "" then
        config = vim.json.decode(json_str)
      end
    end
    for k, v in pairs(config) do
      if k == "settings" then
        settings = v
        break
      end
    end
  end
  return settings
end

local read_vsc_cfg_global = function()
  local settings = nil
  local vsc_cfg_path = vim.fn.expand("~/.config/Code/User/settings.json")
  vim.pretty_print(vsc_cfg_path)
  local json_str = read_file(vsc_cfg_path)
  if json_str ~= "" then
    settings = vim.fn.json_decode(json_str)
  end
  return settings
end

local function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

local convert_vsc_cfg = function()
  local vsc_settings_local = read_vsc_cfg_local()
  local vsc_settings_global = read_vsc_cfg_global()
  local nvim_vsc_settings = vim.deepcopy(default_cfg)

  if vsc_settings_global then
    for key, _ in pairs(vsc_settings_global) do
      local sub_key_list = split(key, ".")
      local config = {}
      config[sub_key_list[#sub_key_list]] = vsc_settings_global[key]
      for i = #sub_key_list - 1, 1, -1 do
        local sub_config = {}
        sub_config[sub_key_list[i]] = config
        config = sub_config
      end
      nvim_vsc_settings = vim.tbl_deep_extend("force", nvim_vsc_settings or {}, config)
    end
  end

  if vsc_settings_local then
    for key, _ in pairs(vsc_settings_local) do
      local sub_key_list = split(key, ".")
      local config = {}
      config[sub_key_list[#sub_key_list]] = vsc_settings_local[key]
      for i = #sub_key_list - 1, 1, -1 do
        local sub_config = {}
        sub_config[sub_key_list[i]] = config
        config = sub_config
      end
      nvim_vsc_settings = vim.tbl_deep_extend("force", nvim_vsc_settings or {}, config)
    end
  end

  return nvim_vsc_settings
end

-- local cfg = convert_vsc_cfg()
return convert_vsc_cfg()
