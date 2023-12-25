local spec = {
  enabled = true,
  priority = 1000,
  cond = true,
  name = 'catppuccin',
  opts = {},
  dependencies = {},
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
  if not spec.cond then
    return
  end
  spec.opts = {
    flavour = 'mocha',
    background = {
      light = 'latte',
      dark = 'mocha',
    },
    transparent_background = false,
    show_end_of_buffer = false,
    term_colors = true,
    dim_inactive = {
      enabled = false,
      shade = 'dark',
      percentage = 0.15,
    },
    no_italic = true,
    no_bold = true,
    no_underline = true,
    styles = {
      comments = {},
      conditionals = {},
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      treesitter_context = true,
      notify = true,
      neotree = true,
      mini = {
        enabled = false,
      },
      telescope = {
        enabled = true,
      },
      lsp_trouble = true,
      which_key = true,
      indent_blankline = {
        enabled = true,
        scope_color = "",
        colored_indent_levels = false,
      },
    },
  }
  spec.config = function(_, opts)
    opts = opts or {}

    opts.color_overrides = {
      latte = require('color').overrides('catppuccin', 'latte', opts),
      mocha = require('color').overrides('catppuccin', 'mocha', opts),
    }

    opts.highlight_overrides = {
      latte = require('highlight').overrides('catppuccin', 'latte', opts),
      mocha = require('highlight').overrides('catppuccin', 'mocha', opts),
    }

    require('catppuccin').setup(opts)

    vim.cmd.colorscheme 'catppuccin'
  end
end

function M.spec()
  return spec
end

return M
