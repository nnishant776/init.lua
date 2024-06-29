local M = {}

function M.get_visible_bufs()
  local active_buffers = {}
  local active_tab = vim.api.nvim_get_current_tabpage()
  local active_windows = vim.api.nvim_tabpage_list_wins(active_tab)
  for _, active_window in ipairs(active_windows) do
    table.insert(active_buffers, vim.api.nvim_win_get_buf(active_window))
  end
  return active_buffers
end

--- @param tabpage integer
function M.get_bufs_in_tab(tabpage)
  local active_buffers = {}
  local active_windows = vim.api.nvim_tabpage_list_wins(tabpage)
  for _, active_window in ipairs(active_windows) do
    table.insert(active_buffers, vim.api.nvim_win_get_buf(active_window))
  end
  return active_buffers
end

return M
