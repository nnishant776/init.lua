local M = {}

function M.setup(opts)
  opts = opts or {}

  ---@type Keymap[]
  local keymap = {
    -- Text navigation
    {
      mode = { 'i' },
      input_keys = "<C-b>",
      action = "<ESC>^i",
      opts = { desc = "Goto beginning of line" },
    },
    {
      mode = { 'i' },
      input_keys = "<C-e>",
      action = "<End>",
      opts = { desc = "Goto end of line" },
    },
    {
      mode = { 'i' },
      input_keys = "<C-h>",
      action = "<Left>",
      opts = { desc = "Move left" },
    },
    {
      mode = { 'i' },
      input_keys = "<C-l>",
      action = "<Right>",
      opts = { desc = "Move right" },
    },
    {
      mode = { 'i' },
      input_keys = "<C-j>",
      action = "<Down>",
      opts = { desc = "Move down" },
    },
    {
      mode = { 'i' },
      input_keys = "<C-k>",
      action = "<Up>",
      opts = { desc = "Move up" },
    },
    -- {
    --   mode = { 'i' },
    --   input_keys = "<C-n>",
    --   action = "<Esc>",
    --   opts = { desc = "Exit insert mode" },
    -- },
    -- {
    --   mode = { 'n', 'x' },
    --   input_keys = "j",
    --   action = 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
    --   opts = {
    --     desc = "Move down skipping folds",
    --     expr = true
    --   },
    -- },
    -- {
    --   mode = { 'n', 'x' },
    --   input_keys = "k",
    --   action = 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
    --   opts = {
    --     desc = "Move up skipping folds",
    --     expr = true
    --   },
    -- },
    -- {
    --   mode = { 'n', 'v' },
    --   input_keys = "<Down>",
    --   action = 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
    --   opts = {
    --     desc = "Move down skipping folds",
    --     expr = true
    --   },
    -- },
    -- {
    --   mode = { 'n', 'v' },
    --   input_keys = "<Up>",
    --   action = 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
    --   opts = {
    --     desc = "Move up skipping folds",
    --     expr = true
    --   },
    -- },
    {
      mode = { 'n' },
      input_keys = "[q",
      action = '<cmd>cprev<CR>',
      opts = {
        desc = "Move to previous item in quickfix list",
      },
    },
    {
      mode = { 'n' },
      input_keys = "]q",
      action = '<cmd>cnext<CR>',
      opts = {
        desc = "Move to next item in quickfix list",
      },
    },
    {
      mode = { 'n' },
      input_keys = "[l",
      action = '<cmd>lprevious<CR>',
      opts = {
        desc = "Move to previous item in location list",
      },
    },
    {
      mode = { 'n' },
      input_keys = "]l",
      action = '<cmd>lnext<CR>',
      opts = {
        desc = "Move to next item in location list",
      },
    },
    {
      mode = { 'n' },
      input_keys = "[{",
      action = function()
        local start_line, start_col, _, _ = require('utils.treesitter').context_range()
        if start_line == -1 then
          vim.cmd("normal! [{")
          return
        end
        start_line = start_line + 1
        vim.api.nvim_win_set_cursor(0, { start_line, start_col })
        vim.cmd("normal! _")
      end,
      opts = { desc = "Jump to context start" },
    },
    {
      mode = { 'n' },
      input_keys = "]}",
      action = function()
        local _, _, end_line, end_col = require('utils.treesitter').context_range()
        if end_line == -1 then
          vim.cmd("normal! ]}")
          return
        end
        local last_line = vim.fn.line('$')
        if end_line >= last_line then
          end_line = last_line
        else
          end_line = end_line + 1
        end
        vim.api.nvim_win_set_cursor(0, { end_line, end_col })
        vim.cmd("normal! _")
      end,
      opts = { desc = "Jump to context end" },
    },

    -- Window navigation
    -- {
    --   mode = { 'n' },
    --   input_keys = "<C-h>",
    --   action = "<C-w>h",
    --   opts = { desc = "Jump to window left" },
    -- },
    -- {
    --   mode = { 'n' },
    --   input_keys = "<C-j>",
    --   action = "<C-w>j",
    --   opts = { desc = "Jump to window down" },
    -- },
    -- {
    --   mode = { 'n' },
    --   input_keys = "<C-k>",
    --   action = "<C-w>k",
    --   opts = { desc = "Jump to window up" },
    -- },
    -- {
    --   mode = { 'n' },
    --   input_keys = "<C-l>",
    --   action = "<C-w>l",
    --   opts = { desc = "Jump to window right" },
    -- },

    -- Miscellaneous
    {
      mode = { 'n' },
      input_keys = "<ESC>",
      action = "<cmd> noh <CR>",
      opts = { desc = "Remove highligh" },
    },
    {
      mode = { 'x' },
      input_keys = "p",
      action = 'p:let @+=@0<CR>:let @"=@0<CR>',
      opts = {
        desc = "Restore registers after copy in visual mode",
        silent = true,
        noremap = true,
      }
    },
    {
      mode = { 't' },
      input_keys = "<C-x>",
      action = "<C-\\><C-n>",
      opts = {
        desc = "Escape terminal mode",
      },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>tt",
      action = function()
        local background = vim.o.background
        if background == 'light' then
          background = 'dark'
        else
          background = 'light'
        end
        require('utils.ui').set_theme(background)
      end,
      opts = {
        desc = 'Toggle dark mode',
      },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>bw",
      action = function()
        vim.cmd [[ bwipeout ]]
      end,
      opts = {
        desc = 'Delete buffer',
      },
    }
  }

  for _, km in ipairs(keymap) do
    km.opts = vim.tbl_deep_extend("keep", km.opts, opts)
    vim.keymap.set(km.mode, km.input_keys, km.action, km.opts)
  end
end

return M
