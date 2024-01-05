local M = {}

function M.global(opts)
  local colors = require('color.global').get(opts)
  return colors
end

function M.overrides(theme, flavor, opts)
  local path = 'color.overrides' .. '.' .. theme .. '.' .. flavor
  local is_override_present, color_override = pcall(require, path)
  if not is_override_present then
    return {}
  end
  return color_override.get(opts)
end

return M
