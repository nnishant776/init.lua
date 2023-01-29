-- Chadrc overrides this file

vim.g.config = require("custom.rtconfig")

local M = {}

M.options = {
  nvChad = {
    update_url = "https://github.com/NvChad/NvChad",
    update_branch = "main",
  },
}

M.ui = {
  -- hl = highlights
  hl_add = require("custom.highlights").add,
  hl_override = require("custom.highlights").override,

  changed_themes = {},
  theme_toggle = { "onedark", "one_light" },
  theme = "onedark", -- default theme
}

M.plugins = require("custom.plugins")

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
