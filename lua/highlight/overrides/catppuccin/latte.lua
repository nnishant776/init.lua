local M = {}

local function init_highlights(opts)
  return function(colors)
    local highlights = {
      Pmenu = { fg = colors.text, bg = require('catppuccin.palettes.latte').base },
      PmenuSel = { fg = colors.text, bg = colors.crust },
      CmpPmenu = { link = "Pmenu" },
      CmpNormalFloat = { link = "CmpPmenu" },
      CmpFloatBorder = { bg = colors.none },
      CmpBorderBG = { bg = colors.none },
      NormalFloat = { link = "Pmenu" },
      Visual = { bg = colors.mantle },
      Search = { fg = "Black", bg = "Orange" },
      NeotreeNormal = { bg = colors.crust },
      NeotreeNormalNC = { bg = colors.crust },
      LspReferenceText = { bg = colors.text, fg = colors.base },
      LspReferenceRead = { bg = colors.text, fg = colors.base },
      LspReferenceWrite = { bg = colors.text, fg = colors.base },
      LineNr = { bg = colors.none, fg = "Grey" },
      CursorLineNr = { bg = colors.none, fg = "LightGrey" },
    }
    return highlights
  end
end

function M.get(opts)
  return init_highlights(opts)
end

return M
