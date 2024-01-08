local M = {}

local icons = {
  Class = "󰠱 ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Enum = " ",
  EnumMember = " ",
  Field = "󰄶 ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = " ",
  Method = "ƒ ",
  Module = " ",
  Property = "󰜢 ",
  Struct = " ",
  Text = " ",
  Unit = " ",
  Value = "󰎠 ",
  Variable = "α ",
  Event = " ",
  Operator = "󰆕 ",
  TypeParameter = "󰅲 ",
  Reference = " ",
  Keyword = "󰌋 ",
  Snippet = " ",
}

function M.icons()
  return icons
end

return M
