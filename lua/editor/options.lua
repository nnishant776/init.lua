vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

local M = {}

function M.load(cfg, opts)
  if not cfg then
    return
  end

  opts = opts or {}
  local bufnr = opts.buf_id
  if opts.buf_id and opts.buf_id ~= -1 then
    opts = { scope = "local" }
  else
    opts = {}
  end

  -- Global settings
  if opts.scope == nil or opts.scope == "global" then
    vim.api.nvim_set_option_value('ruler', false, {})
    vim.api.nvim_set_option_value('completeopt', 'menu,menuone,noselect', {})
    vim.api.nvim_set_option_value('autowrite', true, {})
    vim.api.nvim_set_option_value('timeoutlen', 1000, {})
    vim.api.nvim_set_option_value('updatetime', 250, {})
    vim.api.nvim_set_option_value('ttyfast', true, {})
    vim.api.nvim_set_option_value('backspace', 'indent,eol,start', {})
    vim.api.nvim_set_option_value('cmdheight', 1, {})
    vim.api.nvim_set_option_value('lazyredraw', true, {})
    vim.api.nvim_set_option_value('swapfile', false, {})
    vim.api.nvim_set_option_value('clipboard', '', {})
    vim.api.nvim_set_option_value('incsearch', false, {})
    vim.api.nvim_set_option_value('conceallevel', 3, {})
    vim.api.nvim_set_option_value('confirm', true, {})
    vim.api.nvim_set_option_value('grepformat', '%f:%l:%c:%m', {})
    vim.api.nvim_set_option_value('grepprg', 'rg --vimgrep', {})
    vim.api.nvim_set_option_value('inccommand', 'nosplit', {})
    vim.api.nvim_set_option_value('laststatus', 3, {})
    vim.api.nvim_set_option_value('mouse', 'a', {})
    vim.api.nvim_set_option_value('pumblend', 0, {})
    vim.api.nvim_set_option_value('pumheight', 20, {})
    vim.api.nvim_set_option_value('pumwidth', 50, {})
    vim.api.nvim_set_option_value('scrolloff', 5, {})
    vim.api.nvim_set_option_value('sessionoptions',
      'buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds',
      {})
    vim.api.nvim_set_option_value('foldlevel', 99, {})
    vim.api.nvim_set_option_value('numberwidth', 5, {})
    vim.api.nvim_set_option_value('formatoptions', 'jcqrlont', {})
    vim.api.nvim_set_option_value('modelines', 1, {})
    vim.api.nvim_set_option_value('shiftround', true, {})
    vim.api.nvim_set_option_value('shortmess', 'ltToOCFWIc', {})
    vim.api.nvim_set_option_value('showmode', false, {})
    vim.api.nvim_set_option_value('sidescrolloff', 8, {})
    vim.api.nvim_set_option_value('ignorecase', true, {})
    vim.api.nvim_set_option_value('smartcase', true, {})
    vim.api.nvim_set_option_value('smartindent', true, {})
    vim.api.nvim_set_option_value('spelllang', 'en', {})
    vim.api.nvim_set_option_value('splitbelow', true, {})
    vim.api.nvim_set_option_value('splitkeep', 'screen', {})
    vim.api.nvim_set_option_value('splitright', true, {})
    vim.api.nvim_set_option_value('termguicolors', true, {})
    vim.api.nvim_set_option_value('undofile', true, {})
    vim.api.nvim_set_option_value('undolevels', 10000, {})
    vim.api.nvim_set_option_value('virtualedit', 'block', {})
    vim.api.nvim_set_option_value('wildmode', 'longest:full,full', {})
    vim.api.nvim_set_option_value('winminwidth', 5, {})
    if cfg.editor.showSignColumn then
      vim.api.nvim_set_option_value('signcolumn', 'yes', {})
    else
      vim.api.nvim_set_option_value('signcolumn', 'no', {})
    end
    if vim.fn.has 'nvim-0.10' == 1 then
      vim.api.nvim_set_option_value('smoothscroll', cfg.editor.cursorSmoothCaretAnimation == "on", {})
    end
    vim.api.nvim_set_option_value('listchars', 'trail:·,tab:➝ ,lead:·', {})
    -- foldopen = '',
    -- foldclose = '',
    -- fold = ' ',
    -- foldsep = ' ',
    -- diff = '╱',
    -- eob = ' ',
  end

  -- Buffer settings
  if opts.scope and opts.scope == "local" then
    vim.api.nvim_set_option_value('number', cfg.editor.lineNumbers ~= 'off', opts)
    vim.api.nvim_set_option_value('relativenumber', cfg.editor.lineNumbers == 'relative', opts)
    vim.api.nvim_set_option_value('list', cfg.editor.renderWhitespace ~= 'none', opts)
    vim.api.nvim_set_option_value('shiftwidth', cfg.editor.tabSize, opts)
    vim.api.nvim_set_option_value('tabstop', cfg.editor.tabSize, opts)
    vim.api.nvim_set_option_value('softtabstop', cfg.editor.tabSize, opts)
    vim.api.nvim_set_option_value('expandtab', cfg.editor.insertSpaces, opts)
    vim.api.nvim_set_option_value('cursorline', cfg.editor.highlightLine, opts)
    vim.api.nvim_set_option_value('autoindent', cfg.editor.autoIndent ~= 'none', opts)
    vim.api.nvim_set_option_value('colorcolumn', table.concat(cfg.editor.rulers or { 9999 }, ','), opts)
    vim.api.nvim_set_option_value('wrap', cfg.editor.wordWrap ~= '', opts)
    vim.api.nvim_set_option_value('wrapmargin', cfg.editor.wordWrapColumn, opts)
    vim.api.nvim_set_option_value('textwidth', cfg.editor.wordWrapColumn, opts)
  end
end

return M
