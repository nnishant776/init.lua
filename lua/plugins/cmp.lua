local spec = {
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'windwp/nvim-autopairs',
  },
}

local M = {}

function M.is_enabled(profile, editorconfig)
  if profile.minimal or profile.default then
    return false
  else
    return editorconfig.editor.suggest.enabled
  end
end

function M.setup(profile, editorconfig)
  spec.cond = M.is_enabled(profile, editorconfig)
  if not spec.cond then
    return
  end
  spec.config = function(_, opts)
    local is_cmp_present, cmp = pcall(require, "cmp")

    if not is_cmp_present then
      return
    end

    local lsputil = require('ui.lsp')

    local cmp_window = require "cmp.utils.window"
    cmp_window.info_ = cmp_window.info
    cmp_window.info = function(self)
      local info = self:info_()
      info.scrollable = false
      return info
    end

    opts = vim.tbl_deep_extend("force", opts, {
      enabled = function()
        -- disable completion in comments
        local context = require "cmp.config.context"
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == "c" then
          return true
        else
          local is_suggest_enabled = editorconfig.editor.suggest.enabled
          local is_comment_suggest_enabled = not context.in_treesitter_capture "comment"
              and not context.in_syntax_group "Comment"
          if not is_suggest_enabled then
            return false
          end
          return is_comment_suggest_enabled or editorconfig.editor.quickSuggestions.comments ~= "off"
        end
      end,
      window = {
        completion = {
          winhighlight =
          "Normal:CmpPmenu,NormalFloat:CmpNormalFloat,FloatBorder:CmpFloatBorder,BorderBG:CmpBorderBG,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          winhighlight =
          "Normal:CmpPmenu,NormalFloat:CmpNormalFloat,FloatBorder:CmpFloatBorder,BorderBG:CmpBorderBG,CursorLine:PmenuSel,Search:None",
          side_padding = 2,
        },
      },
      preselect = cmp.PreselectMode.None,
      completion = {
        autocomplete = (function()
          if editorconfig.editor.suggestOnTriggerCharacters then
            return {
              require("cmp.types").cmp.TriggerEvent.InsertEnter,
              require("cmp.types").cmp.TriggerEvent.TextChanged,
            }
          else
            return {}
          end
        end)(),
        keyword_count = 3,
      },
      snippet = {
        expand = function(args)
          local is_luasnip_present, luasnip = pcall(require, "luasnip")
          if is_luasnip_present then
            luasnip.lsp_expand(args.body)
          end
        end,
      },
      matching = {
        disable_fuzzy_matching = (function()
          return editorconfig.editor.suggest.filterGraceful
        end)(),
      },
      formatting = {
        fields = { "kind", "menu", "abbr" },
        format = function(_, item)
          local icons = lsputil.icons()
          local kind = item.kind
          local abbr = item.abbr
          item.kind = string.format("%3s", icons[kind] or '')
          item.menu = abbr
          item.abbr = string.format(" %-10s", kind)
          return item
        end
      },
      mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
          behavior = (function()
            if editorconfig.editor.suggest.insertMode == "replace" then
              return cmp.ConfirmBehavior.Replace
            else
              return cmp.ConfirmBehavior.Insert
            end
          end)(),
          select = false,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
          local is_luasnip_present, luasnip = pcall(require, "luasnip")
          if cmp.visible() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          elseif is_luasnip_present and luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          local is_luasnip_present, luasnip = pcall(require, "luasnip")
          if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
          elseif is_luasnip_present and luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
      },
      experimental = {
        ghost_text = editorconfig.editor.suggest.preview,
      },
      sources = (function()
        local cmp_sources = {
          { name = "nvim_lsp", keyword_count = 3 },
          { name = "nvim_lua" },
        }
        if editorconfig.editor.suggest.showSnippets then
          table.insert(cmp_sources, { name = "luasnip" })
        end
        if editorconfig.editor.suggest.showWords or editorconfig.editor.wordBasedSuggestions then
          table.insert(cmp_sources, { name = "buffer" })
        end
        if editorconfig.editor.suggest.showFiles then
          table.insert(cmp_sources, { name = "path" })
        end
        return cmp_sources
      end)(),
    })

    cmp.setup(opts)

    -- Insert `(` after select function or method item
    local is_cmp_autopairs_present, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
    if is_cmp_autopairs_present then
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  end
end

function M.spec()
  return spec
end

return M
