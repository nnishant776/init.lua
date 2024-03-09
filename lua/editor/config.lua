local M = {}

local fsutils = require('utils.fs')

local function read_project_config()
  local config = {}
  local settings = {}
  local workspace_cfg_list = vim.fn.glob('*.code-workspace')
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

local function read_global_config()
  local settings = {}
  local vsc_cfg_path = vim.fn.expand('~/.config/nvim/settings.json')
  local json_str = fsutils.read_file(vsc_cfg_path)
  if json_str ~= '' then
    settings = vim.fn.json_decode(json_str)
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
function M.parse_key_val(key, val, ignore_pattern_list)
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

local function parse_external_config(input_config)
  local parsed_config = {}

  for key, val in pairs(input_config) do
    if type(key) == 'number' --[[ or not string.match(key, "**") ]]
    then
      return nil
    end
    if type(val) == 'table' then
      local new_val = parse_external_config(val)
      if new_val then
        val = new_val
      end
    end
    local config = M.parse_key_val(key, val, { '%*%*' })
    if config then
      parsed_config = vim.tbl_deep_extend('force', parsed_config or {}, config)
    end
  end

  return parsed_config
end

--- @param default_cfg? any
function M.parse_config(default_cfg)
  if not default_cfg then
    default_cfg = {}
  end

  local local_config = read_project_config()
  local global_config = read_global_config()
  local nvim_config = vim.deepcopy(default_cfg)

  if global_config then
    local parsed_global_config = parse_external_config(global_config)
    if parsed_global_config then
      nvim_config = vim.tbl_deep_extend('force', nvim_config, parsed_global_config)
    end
  end

  if local_config then
    local parsed_local_config = parse_external_config(local_config)
    if parsed_local_config then
      nvim_config = vim.tbl_deep_extend('force', nvim_config, parsed_local_config)
    end
  end

  return nvim_config
end

return M
