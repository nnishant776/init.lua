local M = {}

local all_plugin_list = {
  -- Colorschemes
  'navarasu/onedark.nvim',
  'catppuccin/nvim',

  -- Icons
  'nvim-tree/nvim-web-devicons',

  -- File explorer
  'nvim-neo-tree/neo-tree.nvim',

  -- VCS
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'lewis6991/gitsigns.nvim',
  'NeogitOrg/neogit',

  -- Editing
  'tpope/vim-sleuth',
  'numToStr/Comment.nvim',

  -- Highlighting and Indentation
  'lukas-reineke/indent-blankline.nvim',
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-textobjects',
  'nvim-treesitter/nvim-treesitter-context',

  -- LSP and Suggestions
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'j-hui/fidget.nvim',

  -- Language server managers
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- Snippets
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'rafamadriz/friendly-snippets',
  'windwp/nvim-autopairs',

  -- Help
  'folke/which-key.nvim',

  -- UI
  'nvim-lualine/lualine.nvim',

  -- Command, Control and Navigation
  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-fzf-native.nvim',

  -- Async runtime library
  'nvim-lua/plenary.nvim',
}

local primary_plugin_list = {
  -- Colorschemes
  'navarasu/onedark.nvim',
  'catppuccin/nvim',

  -- File explorer
  'nvim-neo-tree/neo-tree.nvim',

  -- Icons
  'nvim-tree/nvim-web-devicons',

  -- VCS
  'tpope/vim-fugitive',
  'NeogitOrg/neogit',

  -- Editing
  'tpope/vim-sleuth',
  'numToStr/Comment.nvim',

  -- Highlighting and Indentation
  'lukas-reineke/indent-blankline.nvim',
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-context',

  -- LSP and Suggestions
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- Snippets
  'L3MON4D3/LuaSnip',

  -- UI
  'nvim-lualine/lualine.nvim',

  -- Command, Control and Navigation
  'nvim-telescope/telescope.nvim',
}

local name_mapper = {
  ['navarasu/onedark.nvim'] = 'onedark',
  ['catppuccin/nvim'] = 'catppuccin',
  ['nvim-tree/nvim-web-devicons'] = 'nvim-web-devicons',
  ['tpope/vim-fugitive'] = 'fugitive',
  ['tpope/vim-rhubarb'] = 'rhubarb',
  ['lewis6991/gitsigns.nvim'] = 'gitsigns',
  ['tpope/vim-sleuth'] = 'sleuth',
  ['numToStr/Comment.nvim'] = 'Comment',
  ['lukas-reineke/indent-blankline.nvim'] = 'ibl',
  ['nvim-treesitter/nvim-treesitter'] = 'nvim-treesitter',
  ['nvim-treesitter/nvim-treesitter-textobjects'] = 'nvim-treesitter-textobjects',
  ['nvim-treesitter/nvim-treesitter-context'] = 'treesitter-context',
  ['neovim/nvim-lspconfig'] = 'lspconfig',
  ['hrsh7th/nvim-cmp'] = 'cmp',
  ['L3MON4D3/LuaSnip'] = 'luasnip',
  ['saadparwaiz1/cmp_luasnip'] = 'cmp_luasnip',
  ['hrsh7th/cmp-nvim-lua'] = 'cmp-nvim-lua',
  ['hrsh7th/cmp-nvim-lsp'] = 'cmp_nvim_lsp',
  ['hrsh7th/cmp-buffer'] = 'cmp_buffer',
  ['hrsh7th/cmp-path'] = 'cmp_path',
  ['folke/which-key.nvim'] = 'whichkey',
  ['nvim-lualine/lualine.nvim'] = 'lualine',
  ['nvim-telescope/telescope.nvim'] = 'telescope',
  ['nvim-lua/plenary.nvim'] = 'plenary',
  ['nvim-neo-tree/neo-tree.nvim'] = 'neo-tree',
  ['williamboman/mason.nvim'] = 'mason',
  ['williamboman/mason-lspconfig.nvim'] = 'mason-lspconfig',
  ['windwp/nvim-autopairs'] = 'nvim-autopairs',
  ['j-hui/fidget.nvim'] = 'fidget',
  ['NeogitOrg/neogit'] = 'neogit',
}

function M.list_all()
  return all_plugin_list
end

function M.list_primary()
  return primary_plugin_list
end

function M.load(profile, editorconfig)
  local plugins = {}
  for _, plugin in ipairs(primary_plugin_list) do
    local p = vim.tbl_deep_extend('force', { plugin }, M.spec(plugin, profile, editorconfig))
    table.insert(plugins, p)
  end
  return plugins
end

function M.spec(name, profile, editorconfig)
  local default_spec = { name }

  local plug_name = name_mapper[name] or ''
  if plug_name ~= '' then
    plug_name = 'plugins.' .. plug_name
  else
    return {}
  end

  local is_present, plug = pcall(require, plug_name)
  if not is_present then
    return default_spec
  end

  plug.setup(profile, editorconfig)

  local spec = vim.deepcopy(plug.spec()) or default_spec

  local deplist = {}

  if spec.dependencies then
    for _, dep in ipairs(spec.dependencies) do
      local d = vim.tbl_deep_extend('force', { dep }, M.spec(dep, profile, editorconfig))
      table.insert(deplist, d)
    end
  end

  spec.dependencies = deplist

  return spec
end

return M
