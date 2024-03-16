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

return M
