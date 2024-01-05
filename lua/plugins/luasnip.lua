local spec = {
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {},
}

local M = {}

function M.is_enabled(profile, editorconfig)
  if profile.minimal or profile.default then
    return false
  else
    return editorconfig.editor.suggest.showSnippets
  end
end

function M.setup(profile, editorconfig)
  spec.cond = M.is_enabled(profile, editorconfig)
end

function M.spec()
  return spec
end

return M
