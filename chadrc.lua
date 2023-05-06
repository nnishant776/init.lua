-- Chadrc overrides this file

local feature_config = require("custom.features")
local _, active_feature_set = feature_config.parse_feature()

vim.g.buf_config = {}
vim.g.config = vim.deepcopy(active_feature_set.editorconfig)
vim.g.default_config = vim.deepcopy(vim.g.config)

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

-- M.plugins = require("custom.plugins")
M.plugins = active_feature_set.plugins

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
