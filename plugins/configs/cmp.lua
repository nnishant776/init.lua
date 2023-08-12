local present, cmp = pcall(require, "cmp")

if not present then
  return
end

require("base46").load_highlight "cmp"

vim.o.completeopt = "menu,menuone,noselect"

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local cmp_window = require "cmp.utils.window"

cmp_window.info_ = cmp_window.info
cmp_window.info = function(self)
  local info = self:info_()
  info.scrollable = false
  return info
end

local options = {
  enabled = function()
    -- disable completion in comments
    local context = require 'cmp.config.context'
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      local is_suggest_enabled = vim.g.config.editor.suggest.enabled
      local is_comment_suggest_enabled = not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
      if not is_suggest_enabled then
        return false
      end
      return is_comment_suggest_enabled or vim.g.config.editor.quickSuggestions.comments ~= "off"
    end
  end,
  window = {
    completion = {
      border = border "CmpBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = border "CmpDocBorder",
    },
  },
  preselect = cmp.PreselectMode.None,
  completion = {
    autocomplete = (function()
      if vim.g.config.editor.suggestOnTriggerCharacters then
        return {
          require('cmp.types').cmp.TriggerEvent.InsertEnter,
          require('cmp.types').cmp.TriggerEvent.TextChanged,
        }
      else
        return {}
      end
    end)(),
    keyword_count = 3,
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  matching = {
    disable_fuzzy_matching = (function()
      return vim.g.config.editor.suggest.filterGraceful
    end)(),
  },
  formatting = {
    format = function(_, vim_item)
      local icons = require("nvchad_ui.icons").lspkind
      vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
      return vim_item
    end,
  },
  mapping = {
    -- ["<C-p>"] = cmp.mapping.select_prev_item(),
    -- ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-u>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = (function()
        if vim.g.config.editor.suggest.insertMode == "replace" then
          return cmp.ConfirmBehavior.Replace
        else
          return cmp.ConfirmBehavior.Insert
        end
      end)(),
      select = false,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif require("luasnip").expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      elseif require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  experimental = {
    ghost_text = vim.g.config.editor.suggest.preview
  },
  sources = (function()
    local cmp_sources = {
      { name = "nvim_lsp", keyword_count = 3 },
      { name = "nvim_lua" },
    }

    if vim.g.config.editor.suggest.showSnippets then
      table.insert(cmp_sources, { name = "luasnip" })
    end

    if vim.g.config.editor.suggest.showWords or vim.g.config.editor.wordBasedSuggestions then
      table.insert(cmp_sources, { name = "buffer" })
    end

    if vim.g.config.editor.suggest.showFiles then
      table.insert(cmp_sources, { name = "path" })
    end

    return cmp_sources
  end)()
}

-- check for any override
options = require("core.utils").load_override(options, "hrsh7th/nvim-cmp")

cmp.setup(options)
