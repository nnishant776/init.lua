local plugins = {
  ["NvChad/ui"] = {
    override_options = require("custom.plugins.overrides.ui"),
  },
  ["lukas-reineke/indent-blankline.nvim"] = {
    override_options = {
      enabled = vim.g.config.editor.guides.indentation,
      show_current_context = vim.g.config.editor.guides.highlightActiveIndentation,
      show_current_context_start = vim.g.config.editor.guides.highlightActiveIndentation,
    }
  },
  ["tpope/vim-fugitive"] = {},
  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = require("custom.plugins.overrides.treesitter"),
  },
  ["nvim-treesitter/playground"] = {
    module = "playground",
    setup = function()
      require("core.lazy_load").on_file_open("playground")
    end,
  },
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "custom.plugins.configs.lspconfig"
    end,
  },
  ["hrsh7th/nvim-cmp"] = {
    after = "friendly-snippets",
    config = function()
      require "custom.plugins.configs.cmp"
    end,
  },
  ["nvim-tree/nvim-tree.lua"] = {
    override_options = require("custom.plugins.overrides.nvimtree"),
  },
  ["nvim-telescope/telescope.nvim"] = {
    override_options = require("custom.plugins.overrides.telescope"),
  },
  ["williamboman/mason.nvim"] = {
    override_options = require("custom.plugins.overrides.mason"),
  },
  ["lewis6991/gitsigns.nvim"] = {},
  -- debugging
  -- ["mfussenegger/nvim-dap"] = {
  --   opt = true,
  --   event = "BufReadPre",
  --   module = { "dap" },
  --   wants = {
  --     "nvim-dap-virtual-text",
  --     "DAPInstall.nvim",
  --     "nvim-dap-ui",
  --     "nvim-dap-python",
  --     -- "which-key.nvim",
  --   },
  --   requires = {
  --     "Pocco81/DAPInstall.nvim",
  --     "theHamsta/nvim-dap-virtual-text",
  --     "rcarriga/nvim-dap-ui",
  --     "mfussenegger/nvim-dap-python",
  --     "nvim-telescope/telescope-dap.nvim",
  --     { "leoluz/nvim-dap-go", module = "dap-go" },
  --     -- { "jbyuki/one-small-step-for-vimkind", module = "osv" },
  --   },
  -- },
}

return plugins
