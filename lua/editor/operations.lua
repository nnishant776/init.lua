local M = {}

function M.trim_final_newlines(buf_id)
  buf_id = buf_id or 0
  local total_lines = vim.api.nvim_buf_line_count(buf_id)
  for line = total_lines - 1, -1, -1 do
    local lines = vim.api.nvim_buf_get_lines(buf_id, line, line + 1, false)
    local line_content = lines[1]
    if line_content and line_content ~= '' then
      if line + 1 >= total_lines then
        break
      end
      vim.api.nvim_buf_set_lines(buf_id, line + 1, total_lines, true, {})
      break
    end
  end
end

-- FIXME: This API ddesn't support buffer specific operation and will always
-- assume the current buffer. This is due to a lack of a performant algorithm.
-- Will fix later.
function M.trim_trailing_whitespace(buf_id)
  vim.cmd [[ silent! %s/[\ \t]\+$//g ]]
  -- buf_id = buf_id or 0
  -- local total_lines = vim.api.nvim_buf_line_count(buf_id)
  -- for line = total_lines - 1, -1, -1 do
  --   local lines = vim.api.nvim_buf_get_lines(buf_id, line, line + 1, true)
  --   local line_content = lines[1]
  --   if line_content ~= nil and line_content ~= '' then
  --     local last_char_idx = #line_content
  --     for i = #line_content, -1, -1 do
  --       last_char_idx = i
  --       if string.sub(line_content, i, i) ~= ' ' then
  --         break
  --       end
  --     end
  --     if last_char_idx ~= #line_content then
  --       line_content = string.sub(line_content, 1, last_char_idx)
  --     end
  --     vim.api.nvim_buf_set_lines(buf_id, line, line + 1, true, { line_content })
  --   end
  -- end
end

return M
