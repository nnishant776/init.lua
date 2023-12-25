vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

vim.g.config = {}
vim.g.ft_config = {}

local profile = require('profiles').init()
local editor = require('editor')
local editorconfig = editor.config(profile)
local plugins = require('plugins').load(profile, editorconfig)

editor.init(editorconfig)

vim.g.config = vim.deepcopy(editorconfig)
vim.g.default_config = vim.deepcopy(vim.g.config)

require('lazy').setup(plugins)
