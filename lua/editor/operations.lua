local M = {}

function M.trim_final_newlines(buf_id)
  buf_id = buf_id or 0
  local total_lines = vim.api.nvim_buf_line_count(buf_id)
  for line = total_lines - 1, -1, -1 do
    local lines = vim.api.nvim_buf_get_lines(buf_id, line, line + 1, false)
    local line_content = lines[1]
    if line_content ~= '' then
      vim.api.nvim_buf_set_lines(buf_id, line + 1, total_lines, false, {})
      break
    end
  end
end

function M.trim_trailing_whitespace(buf_id)
  buf_id = buf_id or 0
  local total_lines = vim.api.nvim_buf_line_count(buf_id)
  for line = total_lines - 1, -1, -1 do
    local lines = vim.api.nvim_buf_get_lines(buf_id, line, line + 1, true)
    local line_content = lines[1]
    if line_content ~= '' then
      vim.api.nvim_buf_set_lines(buf_id, line, line + 1, true, { vim.trim(line_content) })
      break
    end
  end
end

return M
