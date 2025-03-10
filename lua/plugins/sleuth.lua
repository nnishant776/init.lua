local spec = {
  enabled = true,
  cond = true,
  dependencies = {},
}

local M = {}

function M.is_enabled(profile, editorconfig)
  if profile.level <= 2 then
    return false
  else
    return editorconfig.editor.detectIndentation
  end
end

function M.setup(profile, editorconfig)
  spec.cond = M.is_enabled(profile, editorconfig)
end

function M.spec()
  return spec
end

return M
