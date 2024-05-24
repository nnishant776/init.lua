local spec = {
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
}

local M = {}

function M.is_enabled(profile, editorconfig)
  if profile.minimal or profile.default then
    return false
  else
    return true
  end
end

function M.setup(profile, editorconfig)
  spec.cond = M.is_enabled(profile, editorconfig)
  if spec.cond then
    spec.config = function(_, opts)
      require('luasnip').setup(opts)
      require('luasnip.loaders.from_vscode').lazy_load()
    end
  end
end

function M.spec()
  return spec
end

return M
