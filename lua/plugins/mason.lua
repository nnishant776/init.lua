local spec = {
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {},
}

local M = {}

function M.is_enabled(profile, _)
  if profile.level <= 2 then
    return false
  else
    return true
  end
end

function M.setup(profile, editorconfig)
  spec.cond = M.is_enabled(profile, editorconfig)
  if not spec.cond then
    return
  end
  spec.opts = {
    ensure_installed = {
      'lua-language-server',
      'luau-lsp',
    },
  }
  spec.config = function(_, opts)
    opts = vim.tbl_deep_extend('force', opts, spec.opts)
    local is_mason_present, mason = pcall(require, 'mason')
    if not is_mason_present then
      return
    end
    mason.setup(opts)
  end
end

function M.spec()
  return spec
end

return M
