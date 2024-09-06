local spec = {
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {
    'windwp/nvim-autopairs',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
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
      'lua',
      'c',
      'cpp',
      'yaml',
      'bash',
      'dockerfile',
      'json',
      'ninja',
      'cmake',
      'java',
      'make',
      'markdown',
      'meson',
      'proto',
      'python',
      'toml',
      'rust',
      'zig',
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      disable = function(lang, buf)
        local is_file_size_big = require("utils.fs").is_file_size_big(buf, 100 * 1024)
        local is_blacklisted_filetype = (function()
          local blacklisted_file_types = { "lua" }
          for _, ft in ipairs(blacklisted_file_types) do
            if lang == ft then
              return true
            end
          end
          return false
        end)()
        return is_file_size_big or is_blacklisted_filetype
      end,
    },
    indent = {
      enable = editorconfig.editor.autoIndent ~= 'none',
    },
  }
  spec.config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
    vim.cmd [[ set foldmethod=expr ]]
    vim.cmd [[ set foldexpr=nvim_treesitter#foldexpr() ]]
    vim.cmd [[ set nofoldenable ]]
    vim.cmd [[ set syntax=off ]]
  end
end

function M.spec()
  return spec
end

return M
