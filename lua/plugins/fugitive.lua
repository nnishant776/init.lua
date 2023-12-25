local spec = {
  enabled = true,
  cond = true,
  dependencies = {
    'lewis6991/gitsigns.nvim',
  },
}

local M = {}

function M.is_enabled(profile, _)
  if profile.minimal then
    return false
  else
    return true
  end
end

function M.setup(profile, editorconfig)
  spec.cond = M.is_enabled(profile, editorconfig)
end

function M.spec()
  return spec
end

return M
