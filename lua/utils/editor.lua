local M = {}

function M.get_selection_line_range()
  local mode = vim.fn.mode()
  if mode == 'n' then
    return nil
  else
    local line1 = vim.fn.line("v")
    local line2 = vim.fn.line(".")
    if line1 > line2 then
      line1, line2 = line2, line1
    end
    return { line1, line2 }
  end
end

---@class FilePathOpts
---@field buf_id? integer Mutually exclusive with the filename option
---@field filename? string Mutually exclusive with the buf_id option
---@param opts? FilePathOpts
---@return string
function M.get_relative_file_path(opts)
  opts = opts or {}
  local buf_id = opts.buf_id or 0
  local filename = opts.filename
  if filename == nil then
    filename = vim.api.nvim_buf_get_name(buf_id)
  end
  return vim.fn.fnamemodify(filename, ":~:.")
end

return M
