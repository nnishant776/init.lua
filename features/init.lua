local function init_feature_sets(editorconfig)
  local feature_sets = {
    minimal = {
      plugins = {
        ["nvim-lua/plenary.nvim"] = {},
        ["lewis6991/impatient.nvim"] = {},
        ["wbthomason/packer.nvim"] = {},
        ["NvChad/extensions"] = false,
        ["NvChad/base46"] = {},
        ["NvChad/ui"] = {
          override_options = require("custom.plugins.overrides.ui"),
        },
        ["NvChad/nvterm"] = false,
        ["nvim-tree/nvim-web-devicons"] = {},
        ["lukas-reineke/indent-blankline.nvim"] = false,
        ["NvChad/nvim-colorizer.lua"] = false,
        ["nvim-treesitter/nvim-treesitter"] = false,
        ["lewis6991/gitsigns.nvim"] = false,
        ["williamboman/mason.nvim"] = false,
        ["neovim/nvim-lspconfig"] = false,
        ["rafamadriz/friendly-snippets"] = false,
        ["hrsh7th/nvim-cmp"] = false,
        ["L3MON4D3/LuaSnip"] = false,
        ["saadparwaiz1/cmp_luasnip"] = false,
        ["hrsh7th/cmp-nvim-lua"] = false,
        ["hrsh7th/cmp-nvim-lsp"] = false,
        ["hrsh7th/cmp-buffer"] = false,
        ["hrsh7th/cmp-path"] = false,
        ["nvim-treesitter/playground"] = false,
        ["windwp/nvim-autopairs"] = false,
        ["goolord/alpha-nvim"] = false,
        ["numToStr/Comment.nvim"] = false,
        ["nvim-tree/nvim-tree.lua"] = false,
        ["nvim-telescope/telescope.nvim"] = false,
        ["folke/which-key.nvim"] = false,
        ["tpope/vim-fugitive"] = false,
      },
    },
    default = {
      plugins = {
        ["nvim-lua/plenary.nvim"] = {},
        ["lewis6991/impatient.nvim"] = {},
        ["wbthomason/packer.nvim"] = {},
        ["NvChad/extensions"] = {},
        ["NvChad/base46"] = {},
        ["NvChad/ui"] = {
          override_options = require("custom.plugins.overrides.ui"),
        },
        ["NvChad/nvterm"] = {},
        ["nvim-tree/nvim-web-devicons"] = {},
        ["lukas-reineke/indent-blankline.nvim"] = {},
        ["NvChad/nvim-colorizer.lua"] = {},
        ["nvim-treesitter/nvim-treesitter"] = {},
        ["lewis6991/gitsigns.nvim"] = {},
        ["williamboman/mason.nvim"] = {},
        ["neovim/nvim-lspconfig"] = {},
        ["rafamadriz/friendly-snippets"] = {},
        ["hrsh7th/nvim-cmp"] = {},
        ["L3MON4D3/LuaSnip"] = {},
        ["saadparwaiz1/cmp_luasnip"] = {},
        ["hrsh7th/cmp-nvim-lua"] = {},
        ["hrsh7th/cmp-nvim-lsp"] = {},
        ["hrsh7th/cmp-buffer"] = {},
        ["hrsh7th/cmp-path"] = {},
        ["nvim-treesitter/playground"] = {},
        ["windwp/nvim-autopairs"] = {},
        ["goolord/alpha-nvim"] = false,
        ["numToStr/Comment.nvim"] = {},
        ["nvim-tree/nvim-tree.lua"] = {},
        ["nvim-telescope/telescope.nvim"] = {},
        ["folke/which-key.nvim"] = false,
        ["tpope/vim-fugitive"] = false,
      },
    },
    ide = {
      plugins = {
        ["nvim-lua/plenary.nvim"] = {},
        ["lewis6991/impatient.nvim"] = {},
        ["wbthomason/packer.nvim"] = {},
        ["NvChad/extensions"] = {},
        ["NvChad/base46"] = {},
        ["NvChad/ui"] = {
          override_options = require("custom.plugins.overrides.ui"),
        },
        ["NvChad/nvterm"] = {},
        ["nvim-tree/nvim-web-devicons"] = {},
        ["lukas-reineke/indent-blankline.nvim"] = {
          override_options = {
            enabled = editorconfig.editor.guides.indentation,
            show_current_context = editorconfig.editor.guides.highlightActiveIndentation,
            show_current_context_start = editorconfig.editor.guides.highlightActiveIndentation,
          }
        },
        ["NvChad/nvim-colorizer.lua"] = {},
        ["nvim-treesitter/nvim-treesitter"] = {
          override_options = require("custom.plugins.overrides.treesitter"),
        },
        ["nvim-treesitter/nvim-treesitter-context"] = {
          override_options = {
            enable = editorconfig.editor.guides.context,
            max_lines = 0,
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 20,
            trim_scope = 'outer',
            mode = 'cursor',
            separator = nil,
            zindex = 20,
            on_attach = nil,
          }
        },
        ["lewis6991/gitsigns.nvim"] = {},
        ["williamboman/mason.nvim"] = {
          override_options = require("custom.plugins.overrides.mason"),
        },
        ["neovim/nvim-lspconfig"] = {
          config = function()
            require("custom.plugins.configs.lspconfig")
          end,
        },
        ["rafamadriz/friendly-snippets"] = {},
        ["hrsh7th/nvim-cmp"] = {
          after = "friendly-snippets",
          config = function()
            require("custom.plugins.configs.cmp")
          end,
        },
        ["L3MON4D3/LuaSnip"] = {},
        ["saadparwaiz1/cmp_luasnip"] = {},
        ["hrsh7th/cmp-nvim-lua"] = {},
        ["hrsh7th/cmp-nvim-lsp"] = {},
        ["hrsh7th/cmp-buffer"] = {},
        ["hrsh7th/cmp-path"] = {},
        ["nvim-treesitter/playground"] = {
          module = "playground",
          setup = function()
            require("core.lazy_load").on_file_open("playground")
          end,
        },
        ["windwp/nvim-autopairs"] = {},
        ["goolord/alpha-nvim"] = false,
        ["numToStr/Comment.nvim"] = {},
        ["nvim-tree/nvim-tree.lua"] = {
          override_options = require("custom.plugins.overrides.nvimtree"),
        },
        ["nvim-telescope/telescope.nvim"] = {
          override_options = require("custom.plugins.overrides.telescope"),
        },
        ["folke/which-key.nvim"] = false,
        ["tpope/vim-fugitive"] = {
          override_options = {
            opt = true,
          },
        },
      },
    },
    all = {
      plugins = {
        ["nvim-lua/plenary.nvim"] = {},
        ["lewis6991/impatient.nvim"] = {},
        ["wbthomason/packer.nvim"] = {},
        ["NvChad/extensions"] = {},
        ["NvChad/base46"] = {},
        ["NvChad/ui"] = {
          override_options = require("custom.plugins.overrides.ui"),
        },
        ["NvChad/nvterm"] = {},
        ["nvim-tree/nvim-web-devicons"] = {},
        ["lukas-reineke/indent-blankline.nvim"] = {
          override_options = {
            enabled = editorconfig.editor.guides.indentation,
            show_current_context = editorconfig.editor.guides.highlightActiveIndentation,
            show_current_context_start = editorconfig.editor.guides.highlightActiveIndentation,
          }
        },
        ["NvChad/nvim-colorizer.lua"] = {},
        ["nvim-treesitter/nvim-treesitter"] = {
          override_options = require("custom.plugins.overrides.treesitter"),
        },
        ["nvim-treesitter/nvim-treesitter-context"] = {
          override_options = {
            enable = editorconfig.editor.guides.context,
            max_lines = 0,
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 20,
            trim_scope = 'outer',
            mode = 'cursor',
            separator = nil,
            zindex = 20,
            on_attach = nil,
          }
        },
        ["lewis6991/gitsigns.nvim"] = {},
        ["williamboman/mason.nvim"] = {
          override_options = require("custom.plugins.overrides.mason"),
        },
        ["neovim/nvim-lspconfig"] = {
          config = function()
            require("custom.plugins.configs.lspconfig")
          end,
        },
        ["rafamadriz/friendly-snippets"] = {},
        ["hrsh7th/nvim-cmp"] = {
          after = "friendly-snippets",
          config = function()
            require("custom.plugins.configs.cmp")
          end,
        },
        ["L3MON4D3/LuaSnip"] = {},
        ["saadparwaiz1/cmp_luasnip"] = {},
        ["hrsh7th/cmp-nvim-lua"] = {},
        ["hrsh7th/cmp-nvim-lsp"] = {},
        ["hrsh7th/cmp-buffer"] = {},
        ["hrsh7th/cmp-path"] = {},
        ["nvim-treesitter/playground"] = {
          module = "playground",
          setup = function()
            require("core.lazy_load").on_file_open("playground")
          end,
        },
        ["windwp/nvim-autopairs"] = {},
        ["goolord/alpha-nvim"] = false,
        ["numToStr/Comment.nvim"] = {},
        ["nvim-tree/nvim-tree.lua"] = {
          override_options = require("custom.plugins.overrides.nvimtree"),
        },
        ["nvim-telescope/telescope.nvim"] = {
          override_options = require("custom.plugins.overrides.telescope"),
        },
        ["folke/which-key.nvim"] = false,
        ["tpope/vim-fugitive"] = {
          override_options = {
            opt = true,
          },
        },
      },
    },
  }

  return feature_sets
end

local M = {}

local function parse_features()
  local env_features = os.getenv("features")
  local active_feature_set = {
    plugins = {},
    editorconfig = {}
  }
  local feature_list = {
    default = true,
    minimal = false,
    ide = false,
    all = false
  }

  if env_features ~= "" then
    local features = vim.split(env_features, ",")
    for _, feat in ipairs(features) do
      if feat == "minimal" then
        feature_list.minimal = true
        feature_list.default = false
        feature_list.ide = false
      elseif feat == "all" then
        feature_list.default = false
        feature_list.ide = true
        feature_list.all = true
        vim.g.parse_external_editor_config = true
      elseif feat == "ide" then
        feature_list.ide = true
        feature_list.default = false
      end

      if feat == "extconfig" then
        vim.g.parse_external_editor_config = true
      end
    end
  end

  active_feature_set.editorconfig = require("custom.features.rtconfig")

  local feature_sets = init_feature_sets(active_feature_set.editorconfig)

  if feature_list.all then
    active_feature_set.plugins = feature_sets.all.plugins
  elseif feature_list.ide then
    active_feature_set.plugins = feature_sets.ide.plugins
  elseif feature_list.minimal then
    active_feature_set.plugins = feature_sets.minimal.plugins
    active_feature_set.editorconfig.editor.lineNumbers = "off"
    active_feature_set.editorconfig.editor.showPosition = false
    active_feature_set.editorconfig.editor.renderWhitespace = "none"
    active_feature_set.editorconfig.editor.insertSpaces = true
    active_feature_set.editorconfig.editor.highlightLine = false
  else
    active_feature_set.plugins = feature_sets.default.plugins
  end

  return feature_list, active_feature_set
end

M.parse_feature = parse_features

return M
