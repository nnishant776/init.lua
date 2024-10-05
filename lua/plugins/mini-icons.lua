local spec = {
  enabled = true,
  cond = true,
  version = false,
  opts = {
    { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
  },
  dependencies = {},
  init = function()
    package.preload["nvim-web-devicons"] = function()
      local is_mini_icons_present, mini_icons = pcall(require, 'mini.icons')
      if not is_mini_icons_present then
        return
      end
      mini_icons.mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end
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
    -- No need to copy this inside `setup()`. Will be used automatically.
    -- Icon style: 'glyph' or 'ascii'
    style              = 'glyph',

    -- Customize per category. See `:h MiniIcons.config` for details.
    default            = {},
    directory          = {},
    extension          = {},
    file               = {},
    filetype           = {},
    lsp                = {
      ["function"] = { glyph = 'ƒ ' }
    },
    os                 = {},

    -- Control which extensions will be considered during "file" resolution
    use_file_extension = function(ext, file) return true end,
  }
  spec.config = function(_, opts)
    local is_mini_icons_present, mini_icons = pcall(require, 'mini.icons')
    if not is_mini_icons_present then
      return
    end
    opts = opts or {}
    mini_icons.setup(opts)
    local is_cmp_present, _ = pcall(require, 'cmp')
    if is_cmp_present then
      mini_icons.tweak_lsp_kind()
    end
  end
end

function M.spec()
  return spec
end

return M
