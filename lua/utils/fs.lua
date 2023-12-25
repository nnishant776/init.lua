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

return M
