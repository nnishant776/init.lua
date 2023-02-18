vim.opt.shiftwidth = vim.g.config.editor.tabSize
vim.opt.tabstop = vim.g.config.editor.tabSize
vim.opt.softtabstop = vim.g.config.editor.tabSize
vim.opt.expandtab = vim.g.config.editor.insertSpaces
vim.opt.number = vim.g.config.editor.lineNumbers ~= "off"
vim.opt.relativenumber = vim.g.config.editor.lineNumbers == "relative"
vim.opt.ruler = false
vim.opt.shortmess:append "sI"
vim.opt.numberwidth = 4
vim.opt.formatoptions = "jcqrlo"
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.list = vim.g.config.editor.renderWhitespace ~= "none"
vim.opt.listchars = { trail = '·', tab = "➝ ", lead = '·' }
vim.opt.timeoutlen = 1000
vim.opt.updatetime = 250
vim.opt.cursorline = true
vim.opt.autoindent = vim.g.config.editor.detectIndentation
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.ttyfast = true
vim.opt.cmdheight = 1
vim.opt.lazyredraw = true
vim.opt.modelines = 1
vim.opt.colorcolumn = vim.g.config.editor.rulers
