local M = {}

-- Returns the current context bounds
function M.context_range()
  local start_line = -1
  local start_col = -1
  local end_line = -1
  local end_col = -1

  local ts_utils_status, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if not ts_utils_status then
    return start_line, start_col, end_line, end_col
  end

  local locals = require "nvim-treesitter.locals"
  local cursor_node = ts_utils.get_node_at_cursor()

  local current_scope = locals.containing_scope(cursor_node, 0)
  if not current_scope then
    return start_line, start_col, end_line, end_col
  end

  while cursor_node do
    local node_start_line, node_start_col, node_end_line, node_end_col = cursor_node:range()
    local curr_line = vim.fn.line('.')
    if curr_line > 0 then
      curr_line = curr_line - 1
    end
    if node_start_line ~= node_end_line and node_start_line ~= curr_line and node_end_line ~= curr_line then
      start_line = node_start_line
      start_col = node_start_col
      end_line = node_end_line
      end_col = node_end_col
      return start_line, start_col, end_line, end_col
    end
    cursor_node = cursor_node:parent()
  end

  vim.cmd [[normal! _]]
  return start_line, start_col, end_line, end_col
end

return M
