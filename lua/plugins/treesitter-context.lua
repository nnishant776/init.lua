local spec = {
  enabled = true,
  cond = true,
  opts = {
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = 'outer',
    mode = 'cursor',
    separator = nil,
    zindex = 20,
    on_attach = function(buf_id)
      local editor = require('editor')
      local ft_config = editor.bufconfig(buf_id, false)
      if ft_config and ft_config.editor.guides.context then
        return true
      end
      return false
    end,
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
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
  spec.opts.enable = true
end

function M.spec()
  return spec
end

return M
