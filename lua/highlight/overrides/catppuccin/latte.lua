local M = {}

local function init_highlights(opts)
  return function(colors)
    local highlights = {
      Pmenu = { fg = colors.text, bg = require('catppuccin.palettes.latte').base },
      CmpPmenu = { link = "Pmenu" },
      CmpNormalFloat = { link = "CmpPmenu" },
      CmpFloatBorder = { bg = colors.none },
      CmpBorderBG = { bg = colors.none },
      NormalFloat = { link = "Pmenu" },
      Visual = { bg = colors.crust },
      Search = { bg = "Yellow" },
      NeotreeNormal = { bg = colors.crust },
      NeotreeNormalNC = { bg = colors.crust },
    }
    return highlights
  end
end

function M.get(opts)
  return init_highlights(opts)
end

return M
