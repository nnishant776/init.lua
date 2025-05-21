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

local function ibl_config(editorconfig)
  local cfg = {
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
        'git',
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

  return cfg
end

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
  spec.opts = ibl_config(editorconfig)
end

function M.setup_buffer(buf_id, editorconfig)
  if not spec.cond then
    return
  end
  local opts = ibl_config(editorconfig)
  local is_ibl_present, ibl = pcall(require, "ibl")
  if is_ibl_present then
    ibl.setup_buffer(buf_id, opts)
  end
end

function M.spec()
  return spec
end

return M
