local spec = {
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
    'lewis6991/gitsigns.nvim',
    "sindrets/diffview.nvim", -- optional - Diff integration
    "nvim-telescope/telescope.nvim",
  },
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

  spec.opts = {}

  spec.config = function(_, opts)
    -- Setup plugin
    local is_neogit_present, neogit = pcall(require, 'neogit')
    if not is_neogit_present then
      return
    end
    neogit.setup(opts)
  end
end

function M.spec()
  return spec
end

return M
