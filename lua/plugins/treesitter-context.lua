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
    on_attach = nil,
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
  spec.opts.enable = editorconfig.editor.guides.context
end

function M.spec()
  return spec
end

return M
