local M = {}

--- @param buf_id integer buffer number
--- @param size integer maximum file size which is considered big
--- @return boolean
function M.is_file_size_big(buf_id, size)
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf_id))
  if ok and stats and stats.size > size then
    return true
  end
  return false
end

--- @param filename string
function M.read_file(filename)
  local file = io.open(filename, 'r')
  if file ~= nil then
    return file:read('*a')
  else
    return ''
  end
end

--- @param filename string
--- @param content string
function M.write_file(filename, content)
  local file = io.open(filename, 'w')
  if file ~= nil then
    return file:write(content)
  else
    return ''
  end
end

return M
