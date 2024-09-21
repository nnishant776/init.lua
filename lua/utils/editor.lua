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

function M.get_cursor_position(win_id)
  win_id = win_id or 0
  local pos = vim.fn.getcursorcharpos(win_id)
  return { pos[2], pos[3] }
end

function M.split(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

function M.get_grep_args()
  if vim.g.grep_args then
    return vim.deepcopy(vim.g.grep_args)
  end

  local cmd = 'grep'
  local common_args = {
      "--color=never",
      "-H",
      "--line-number",
  }

  local cmd_args = {}
  if vim.fn.executable('rg') == 0 then
    cmd_args = {
      "--recursive",
      "--byte-offset",
      "-I",
    }
    if vim.fn.executable('git') == 1 then
      cmd = 'git'
      cmd_args = {
        "grep",
        "--recursive",
        "--column",
        "--no-index",
        "--exclude-standard",
        "-I",
      }
    end
  else
    cmd = 'rg'
    cmd_args = {
      "--no-follow",
      "--no-heading",
      "--column",
      "--smart-case",
    }
  end

  local grep_args = { cmd }
  for i=1,#cmd_args do
    grep_args[#grep_args+1] = cmd_args[i]
  end
  for i=1,#common_args do
    grep_args[#grep_args+1] = common_args[i]
  end

  vim.g.grep_args = vim.deepcopy(grep_args)

  return grep_args
end

return M
