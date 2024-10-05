local spec = {
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {},
}

local M = {}

function M.is_enabled(profile, _)
  -- if profile.level <= 2 then
  --   return false
  -- else
  --   return true
  -- end
  return false
end

function M.setup(profile, editorconfig)
  spec.cond = M.is_enabled(profile, editorconfig)
end

function M.spec()
  return spec
end

return M
