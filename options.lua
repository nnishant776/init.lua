local function load(cfg)
  vim.opt.shiftwidth = cfg.editor.tabSize
  vim.opt.tabstop = cfg.editor.tabSize
  vim.opt.softtabstop = cfg.editor.tabSize
  vim.opt.expandtab = cfg.editor.insertSpaces
  vim.opt.number = cfg.editor.lineNumbers ~= "off"
  vim.opt.relativenumber = cfg.editor.lineNumbers == "relative"
  vim.opt.ruler = false
  vim.opt.shortmess:append "sI"
  vim.opt.numberwidth = 4
  vim.opt.formatoptions = "jcqrlo"
  vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
  vim.opt.list = cfg.editor.renderWhitespace ~= "none"
  vim.opt.listchars = { trail = '·', tab = "➝ ", lead = '·' }
  vim.opt.timeoutlen = 1000
  vim.opt.updatetime = 250
  vim.opt.cursorline = cfg.editor.highlightLine
  vim.opt.autoindent = cfg.editor.detectIndentation
  vim.opt.backspace = { "indent", "eol", "start" }
  vim.opt.ttyfast = true
  vim.opt.cmdheight = 1
  vim.opt.lazyredraw = true
  vim.opt.modelines = 1
  vim.opt.swapfile = false
  vim.opt.clipboard = ""
  vim.opt.colorcolumn = cfg.editor.rulers
  vim.opt.incsearch = false
end

local function load_buf(cfg, buf_nr)
  vim.bo[buf_nr].shiftwidth = cfg.editor.tabSize
  vim.bo[buf_nr].tabstop = cfg.editor.tabSize
  vim.bo[buf_nr].softtabstop = cfg.editor.tabSize
  vim.bo[buf_nr].expandtab = cfg.editor.insertSpaces
  vim.bo[buf_nr].formatoptions = "jcqrlo"
  vim.bo[buf_nr].autoindent = cfg.editor.detectIndentation
  vim.g.indent_blankline_enabled = cfg.editor.guides.indentation
end
local M = {}

M.load = load
M.load_buf = load_buf

return M
