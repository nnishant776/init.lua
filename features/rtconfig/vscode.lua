local M = {}

local function read_file(filename)
  local file = io.open(filename, "r")
  if file ~= nil then
    return file:read("*a")
  else
    return ""
  end
end

local function read_project_config()
  local config = {}
  local settings = {}
  local workspace_cfg_list = vim.fn.glob("*.code-workspace")
  if workspace_cfg_list ~= "" then
    local workspace_cfgs = vim.split(workspace_cfg_list, "\n", { plain = true })
    local workspace_cfg
    for _, v in ipairs(workspace_cfgs) do
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

local function read_global_config()
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

local function process_config_key_val(key, val, ignore_pattern_list)
  local config = {}

  for _, pat in ipairs(ignore_pattern_list) do
    if string.match(key, pat) then
      return nil
    end
  end

  local sub_key_list = split(key, ".")

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
    if type(key) == "number" --[[ or not string.match(key, "**") ]] then
      return nil
    end
    if type(val) == "table" then
      local new_val = parse_external_config(val)
      if new_val then
        val = new_val
      end
    end
    local config = process_config_key_val(key, val, { "%*%*" })
    if config then
      parsed_config = vim.tbl_deep_extend("force", parsed_config or {}, config)
    end
  end

  return parsed_config
end

local function get_merged_config(default_cfg)
  if not default_cfg then
    default_cfg = {}
  end

  local local_config = read_project_config()
  local global_config = read_global_config()
  local nvim_config = vim.deepcopy(default_cfg)

  if global_config then
    local parsed_global_config = parse_external_config(global_config)
    if parsed_global_config then
      nvim_config = vim.tbl_deep_extend("force", nvim_config, parsed_global_config)
    end
  end

  if local_config then
    local parsed_local_config = parse_external_config(local_config)
    if parsed_local_config then
      nvim_config = vim.tbl_deep_extend("force", nvim_config, parsed_local_config)
    end
  end

  if nvim_config.files.trimFinalNewlines then
    vim.api.nvim_create_augroup("GenericPreWriteTasks", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      callback = function()
        local total_lines = vim.api.nvim_buf_line_count(0)
        for line = total_lines - 1, -1, -1
        do
          local lines = vim.api.nvim_buf_get_lines(0, line, line + 1, false)
          local line_content = lines[1]
          if line_content ~= "" then
            vim.api.nvim_buf_set_lines(0, line + 1, total_lines, false, {})
            break
          end
        end
      end
    })
  end

  if nvim_config.files.trimTrailingWhitespace then
    vim.api.nvim_create_augroup("GenericPreWriteTasks", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      callback = function()
        vim.cmd [[ silent! %s/\s\+$//g ]]
      end
    })
  end

  return nvim_config
end

vim.api.nvim_create_augroup("FileTypeReloadConfig", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype
    if not vim.g.buf_config[ft] then
      local lang_key = "[" .. ft .. "]"
      local workspace_cfg = vim.deepcopy(vim.g.config)
      local lang_config = vim.g.config[lang_key]
      if lang_config then
        workspace_cfg = vim.tbl_deep_extend("force", workspace_cfg, lang_config)
        local new_buf_config = {
          [ft] = workspace_cfg
        }
        vim.g.buf_config = vim.tbl_deep_extend("force", vim.g.buf_config, new_buf_config)
      end
    end
    if not vim.g.buf_config[ft] then
      require("custom.options").load_buf(vim.g.config, bufnr)
    else
      require("custom.options").load_buf(vim.g.buf_config[ft], bufnr)
    end
  end,
  group = "FileTypeReloadConfig",
  desc = "Reload config based on file type"
})

-- vim.api.nvim_create_autocmd({ "BufLeave" }, {
--   callback = function()
--     local lang_key = "[" .. vim.bo.filetype .. "]"
--     local buf_config = vim.g.config[lang_key]
--     if buf_config then
--       vim.g.config = vim.deepcopy(vim.g.default_config)
--       require("custom.options").load()
--     end
--   end,
--   group = "FileTypeReloadConfig",
--   desc = "Restore config on buffer exit"
-- })

M.parse_config = get_merged_config

return M
