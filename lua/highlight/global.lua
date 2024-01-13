local highlights = {
  LineNr = { bg = "NONE", fg = "Grey" },
  CursorLineNr = { bg = "NONE", fg = "Grey" },
}

local M = {}

function M.get(opts)
  return highlights
end

return M
