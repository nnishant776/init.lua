local M = {}

function M.global(opts)
  local colors = require('color.global').get(opts)
  return colors
end

return M
