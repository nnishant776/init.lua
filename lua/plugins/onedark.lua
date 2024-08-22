local spec = {
  priority = 1001,
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {},
}

local M = {}

function M.is_enabled(_, _)
  -- if profile.minimal then
  --   return false
  -- else
  --   return true
  -- end
  return false
end

function M.setup(profile, editorconfig)
  spec.cond = M.is_enabled(profile, editorconfig)
  if not spec.cond then
    return
  end
  spec.opts = {
    style = 'cool',
    transparent = false,
    term_colors = true,
    ending_tildes = true,
    cmp_itemkind_reverse = false,
    toggle_style_list = { 'cool', 'light' },
    code_style = {
      comments = 'none',
      keywords = 'none',
      functions = 'none',
      strings = 'none',
      variables = 'none'
    },
    lualne = {
      transparent = false,
    },
    colors = {},
    highlights = {},
    diagnostics = {
      darker = true,
      undercurl = true,
      background = false,
    },
  }
  spec.config = function(_, opts)
    require('onedark').setup(opts)
    vim.cmd.colorscheme 'onedark'
  end
end

function M.spec()
  return spec
end

return M
