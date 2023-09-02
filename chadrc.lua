-- Chadrc overrides this file

local feature_config = require("custom.features")
local _, active_feature_set = feature_config.parse_feature()

vim.g.config = vim.deepcopy(active_feature_set.editorconfig)
vim.g.buf_config = {}
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

vim.api.nvim_create_user_command("ReloadConfig", function(_)
  local fp = vim.fn.fnamemodify(vim.fn.expand('%h'), ":r") --[[@as string]]
  local app_name = vim.env.NVIM_APPNAME and vim.env.NVIM_APPNAME or "nvim"
  local module = string.gsub(fp, "^.*/" .. app_name .. "/lua/", ""):gsub("/", ".")

  require("plenary.reload").reload_module("base46")
  require("plenary.reload").reload_module(module)
  require("plenary.reload").reload_module("custom.chadrc")

  local config = require("core.utils").load_config()

  vim.g.nvchad_theme = config.ui.theme
  vim.g.transparency = config.ui.transparency

  -- statusline
  -- require("plenary.reload").reload_module("nvchad.statusline." .. config.ui.theme)
  -- vim.opt.statusline = "%!v:lua.require('nvchad.statusline." .. config.ui.theme .. "').run()"

  -- tabufline
  -- if config.ui.tabufline.enabled then
  --   require("plenary.reload").reload_module "nvchad.tabufline.modules"
  --   vim.opt.tabline = "%!v:lua.require('nvchad.tabufline.modules').run()"
  -- end

  require("base46").load_all_highlights()
end, {})

return M
