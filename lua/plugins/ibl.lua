local spec = {
  enabled = true,
  cond = true,
  main = 'ibl',
  opts = {
    enabled = false,
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
}

local M = {}

function M.is_enabled(profile, _)
  if profile.minimal or profile.default then
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
    -- indent = {
    --   char = '▏'
    -- },
    enabled = editorconfig.editor.guides.indentation,
    scope = {
      enabled = editorconfig.editor.guides.highlightActiveIndentation,
      show_start = editorconfig.editor.guides.highlightActiveIndentation,
      show_end = false,
      injected_languages = false,
    },
    exclude = {
      filetypes = {
        '',
        'lspinfo',
        'packer',
        'checkhealth',
        'help',
        'man',
        'gitcommit',
        'TelescopePrompt',
        'TelescopeResults',
        'fugitive',
        'terminal',
        'nofile',
        'quickfix',
        'prompt',
        'fugitive',
      },
      buftypes = {
        'terminal',
        'nofile',
        'quickfix',
        'prompt',
        'fugitive',
      },
    },
  }
end

function M.spec()
  return spec
end

return M
