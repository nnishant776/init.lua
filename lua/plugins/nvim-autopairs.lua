local spec = {
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {},
}

local M = {}

function M.is_enabled(profile, _)
  if profile.minimal or profile.default then
    return false
  else
    return true
  end
end

function M.setup(profile, _)
  spec.cond = M.is_enabled(profile)
  if not spec.cond then
    return
  end
  spec.opts = {
    enable_check_bracket_line = true,
    fast_wrap = {
      map = '<M-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = [=[[%'%"%>%]%)%}%,]]=],
      end_key = '$',
      before_key = 'h',
      after_key = 'l',
      cursor_pos_before = true,
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      manual_position = true,
      highlight = 'Search',
      highlight_grey = 'Comment'
    },
  }
  spec.config = function(_, opts)
    local is_nvim_autopair_present, nvim_autopair = pcall(require, 'nvim-autopairs')
    if not is_nvim_autopair_present then
      return
    end
    nvim_autopair.setup(opts)
  end
end

function M.spec()
  return spec
end

return M
