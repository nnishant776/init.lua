local M = {}

function M.global(opts)
  local highlights = require('highlight.global').get(opts)
  return highlights
end

function M.overrides(theme, flavor, opts)
  local path = 'highlight.overrides' .. '.' .. theme .. '.' .. flavor
  local is_override_present, highlight_override = pcall(require, path)
  if not is_override_present then
    return {}
  end
  return highlight_override.get(opts)
end

return M
