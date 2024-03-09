local M = {}

local exclude = {
  filetypes = {
    ['lspinfo'] = true,
    ['packer'] = true,
    ['checkhealth'] = true,
    ['help'] = true,
    ['man'] = true,
    ['TelescopePrompt'] = true,
    ['TelescopeResults'] = true,
    ['fugitive'] = true,
  },
  buftypes = {
    ['nofile'] = true,
    ['nowrite'] = true,
    ['help'] = true,
    ['terminal'] = true,
    ['quickfix'] = true,
    ['prompt'] = true,
    ['fugitive'] = true,
    ['directory'] = true,
    ['unlisted'] = true,
    ['TelescopePrompt'] = true,
    ['TelescopeResults'] = true,
  },
}

function M.is_buf_valid(buf_id)
  if buf_id == nil or buf_id == -1 then
    return true
  end
  local ft = vim.api.nvim_get_option_value('filetype', { buf = buf_id })
  local bt = vim.api.nvim_get_option_value('buftype', { buf = buf_id })
  local is_hidden = vim.api.nvim_get_option_value('bufhidden', { buf = buf_id })
  if (ft == '' and bt == '') or (is_hidden and is_hidden ~= '') or exclude.buftypes[bt] or exclude.filetypes[ft] then
    return false
  end
  return true
end

--- @param key string
--- @param val any
--- @param ignore_pattern_list table
--- @return table
-- This function takes in a key in the JSON config and the associated
-- value and then converts it into a object hierarchy with the value
-- attached to the leaf node
function M.parse_config_key_val(key, val, ignore_pattern_list)
  local config = {}

  for _, pat in ipairs(ignore_pattern_list) do
    if string.match(key, pat) then
      return config
    end
  end

  local sub_key_list = split(key, '.')

  config[sub_key_list[#sub_key_list]] = val
  for i = #sub_key_list - 1, 1, -1 do
    local sub_config = {}
    sub_config[sub_key_list[i]] = config
    config = sub_config
  end

  return config
end

return M
