local M = {}

local read_file = function(filename)
  local file = io.open(filename, "r")
  if file ~= nil then
    return file:read("*a")
  else
    return ""
  end
end

local read_project_config = function()
  local config = {}
  local settings = {}
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
    if config then
      for k, v in pairs(config) do
        if k == "settings" then
          settings = v
          break
        end
      end
    end
  end
  return settings
end

local read_global_config = function()
  local settings = {}
  local vsc_cfg_path = vim.fn.expand("~/.config/Code/User/settings.json")
  local json_str = read_file(vsc_cfg_path)
  if json_str ~= "" then
    settings = vim.fn.json_decode(json_str)
  end
  if not settings then
    settings = {}
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

local process_config_key_val = function(key, val)
  local sub_key_list = split(key, ".")
  local config = {}
  config[sub_key_list[#sub_key_list]] = val
  for i = #sub_key_list - 1, 1, -1 do
    local sub_config = {}
    sub_config[sub_key_list[i]] = config
    config = sub_config
  end
  return config
end

local get_merged_config = function(default_cfg)
  if not default_cfg then
    default_cfg = {}
  end

  local local_config = read_project_config()
  local global_config = read_global_config()
  local nvim_config = vim.deepcopy(default_cfg)

  if global_config then
    for key, _ in pairs(global_config) do
      local config = process_config_key_val(key, global_config[key])
      if config then
        nvim_config = vim.tbl_deep_extend("force", nvim_config or {}, config)
      end
    end
  end

  if local_config then
    for key, _ in pairs(local_config) do
      local config = process_config_key_val(key, local_config[key])
      if config then
        nvim_config = vim.tbl_deep_extend("force", nvim_config or {}, config)
      end
    end
  end

  return nvim_config
end

M.parse_config = get_merged_config

return M
