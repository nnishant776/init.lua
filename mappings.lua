-- n, v, i, t = mode names

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local M = {}

M.general = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "Goto beginning of line" },
    ["<C-e>"] = { "<End>", "Goto end of line" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "Move left" },
    ["<C-l>"] = { "<Right>", "Move right" },
    ["<C-j>"] = { "<Down>", "Move down" },
    ["<C-k>"] = { "<Up>", "Move up" },

    -- exit insert mode with ctrl + n
    ["<C-n>"] = { "<Esc>", "Exit insert mode" },
  },

  n = {
    ["<ESC>"] = { "<cmd> noh <CR>", "Remove highlight" },

    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "Jump to window left" },
    ["<C-l>"] = { "<C-w>l", "Jump to window right" },
    ["<C-j>"] = { "<C-w>j", "Jump to window down" },
    ["<C-k>"] = { "<C-w>k", "Jump to window up" },

    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "save file" },

    -- Copy all
    -- ["<C-c>"] = { "<cmd> %y+ <CR>", "copy whole file" },

    -- line numbers
    -- ["<leader>n"] = { "<cmd> set nu! <CR>", "Toggle line number" },
    -- ["<leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative line number" },

    -- update nvchad
    -- ["<leader>uu"] = { "<cmd> :NvChadUpdate <CR>", "Update nvchad" },

    ["<leader>tt"] = {
      function()
        require("base46").toggle_theme()
        require("base46").load_all_highlights()
      end,
      "toggle theme",
    },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },

    -- new buffer
    ["<leader>bE"] = { "<cmd> enew <CR>", "New buffer" },
  },

  t = { ["<C-x>"] = { termcodes "<C-\\><C-N>", "escape terminal mode" } },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<TAB>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },

    ["<S-Tab>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },

    -- pick buffers via numbers
    ["<Bslash>"] = { "<cmd> TbufPick <CR>", "Pick buffer" },

    -- close buffer + hide terminal buffer
    ["<leader>x"] = {
      function()
        require("nvchad_ui.tabufline").close_buffer()
      end,
      "Close buffer",
    },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ["<ESC>"] = {
      function()
        vim.cmd([[ noh ]])
        vim.lsp.buf.clear_references()
      end,
      "LSP bindings for Esc",
    },

    -- navigation
    ["gD"] = { function() vim.lsp.buf.declaration() end, "List symbol declaration", },
    ["gd"] = { function() vim.lsp.buf.definition() end, "List symbol definition", },
    ["gi"] = { function() vim.lsp.buf.implementation() end, "List symbol implementation", },
    ["gr"] = { function() vim.lsp.buf.references() end, "List references", },
    ["[d"] = { function() vim.diagnostic.goto_prev() end, "Goto previous diagnostic item", },
    ["]d"] = { function() vim.diagnostic.goto_next() end, "Goto next diagnostic item", },

    -- information and help
    ["K"] = { function() vim.lsp.buf.hover() end, "Show symbol hover", },
    ["<leader>ldf"] = { function() vim.diagnostic.open_float() end, "Show floating diagnostic", },
    ["<leader>lsH"] = { function() vim.lsp.buf.signature_help() end, "Show signature help", },

    -- reference highlight
    ["<leader>lhs"] = { function() vim.lsp.buf.document_highlight() end, "Set reference highlight" },
    ["<leader>lhc"] = { function() vim.lsp.buf.clear_references() end, "Clear reference highlight" },

    -- code actions
    ["<leader>lca"] = { function() vim.lsp.buf.code_action() end, "View code actions", },
    -- ["<leader>q"] = { function() vim.diagnostic.setloclist() end, "Diagnostic setloclist", },

    -- formatting
    ["<leader>lfm"] = { function() vim.lsp.buf.format({ async = true }) end, "Format document", },

    -- workspace folders
    ["<leader>wa"] = { function() vim.lsp.buf.add_workspace_folder() end, "Add workspace folder", },
    ["<leader>wr"] = { function() vim.lsp.buf.remove_workspace_folder() end, "Remove workspace folder", },
    ["<leader>wl"] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List workspace folders", },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<leader>pf"] = { "<cmd> NvimTreeToggle <CR>", "Toggle project files" },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- open telescope
    ["<leader>T"] = { "<cmd> Telescope <CR>", "Open Telescope" },

    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "Find word" },

    -- buffers
    ["<leader>bl"] = { "<cmd> Telescope buffers <CR>", "List buffers" },
    -- ["<leader>lo"] = { "<cmd> Telescope oldfiles <CR>", "List oldfiles" },

    -- help
    ["<leader>ht"] = { "<cmd> Telescope help_tags <CR>", "Show help tags" },
    ["<leader>hk"] = { "<cmd> Telescope keymaps <CR>", "Show keymaps" },

    -- git
    ["<leader>gsc"] = { "<cmd> Telescope git_commits <CR>", "Show git commits" },
    ["<leader>gss"] = { "<cmd> Telescope git_status <CR>", "Show git status" },
    ["<leader>gsf"] = { "<cmd> Telescope git_files <CR>", "Show git files" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

    -- theme switcher
    -- ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Switch themes" },

    -- lsp
    ["<leader>lsW"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "List workspace symbols" },
    ["<leader>lsD"] = { "<cmd> Telescope lsp_document_symbols <CR>", "List document symbols" },
    ["<leader>lsr"] = { "<cmd> Telescope lsp_references <CR>", "List symbol references" },
    ["<leader>lsd"] = { "<cmd> Telescope lsp_definitions <CR>", "List symbol definitions" },
    ["<leader>lst"] = { "<cmd> Telescope lsp_type_definitions <CR>", "List symbol type definitions" },
    ["<leader>lsi"] = { "<cmd> Telescope lsp_implementations <CR>", "List symbol implementations" },
    ["<leader>lsR"] = { function() require("nvchad_ui.renamer").open() end, "Rename symbol" },
    ["<leader>lci"] = { "<cmd> Telescope lsp_incoming_calls <CR>", "List incoming calls" },
    ["<leader>lco"] = { "<cmd> Telescope lsp_outgoing_calls <CR>", "List outgoing calls" },
    ["<leader>lD"] = { "<cmd> Telescope diagnostics <CR>", "List project diagnostics" },
  },
}

M.nvterm = {
  plugin = true,

  t = {
    -- toggle in terminal mode
    ["<A-i>"] = { function() require("nvterm.terminal").toggle "float" end, "Toggle floating terminal", },
    ["<A-h>"] = { function() require("nvterm.terminal").toggle "horizontal" end, "Toggle horizontal terminal", },
    ["<A-v>"] = { function() require("nvterm.terminal").toggle "vertical" end, "Toggle vertical terminal", },
  },

  n = {
    -- toggle in normal mode
    ["<A-i>"] = { function() require("nvterm.terminal").toggle "float" end, "Toggle floating terminal", },
    ["<A-h>"] = { function() require("nvterm.terminal").toggle "horizontal" end, "Toggle horizontal terminal", },
    ["<A-v>"] = { function() require("nvterm.terminal").toggle "vertical" end, "Toggle vertical terminal", },
  },

}

M.whichkey = {
  plugin = true,

  n = {
    ["<leader>wK"] = { function() vim.cmd "WhichKey" end, "Which-key all keymaps", },
    ["<leader>wk"] = { function() local input = vim.fn.input "WhichKey: " vim.cmd("WhichKey " .. input) end,
      "Which-key query lookup", },
  },

}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next change",
      opts = { expr = true },
    },

    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev change",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>ghr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>ghs"] = {
      function()
        require("gitsigns").stage_hunk()
      end,
    },

    ["<leader>ghp"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>gsb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "Blame line",
    },

    ["<leader>gshl"] = {
      function()
        vim.cmd("Git log --format='%h (%an) %s' -L" ..
          vim.fn.line('.') .. ",+1:" .. vim.fn.fnamemodify(vim.fn.expand('%h'), ":~:."))
      end,
    },

    ["<leader>gshf"] = {
      function()
        vim.cmd("Git log --format='%h (%an) %s' -p --follow " .. vim.fn.fnamemodify(vim.fn.expand('%h'), ":~:."))
      end,
    },

    ["<leader>gtd"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted changes",
    },
  },
}

return M
