local highlights = {
  LineNr = { bg = "NONE", fg = "Grey" },
  CursorLineNr = { bg = "NONE", fg = "LightGrey" },
}

local M = {}

function M.get(opts)
  return highlights
end

return M
