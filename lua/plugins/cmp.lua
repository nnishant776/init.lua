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
  if profile.level <= 2 then
    return false
  else
    return true
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

    local cmp_window = require("cmp.utils.window")
    cmp_window.info_ = cmp_window.info
    cmp_window.info = function(self)
      local info = self:info_()
      info.scrollable = false
      return info
    end

    opts = vim.tbl_deep_extend("force", opts, {
      enabled = function()
        -- disable for invalid buffers
        if not require('editor.utils').is_buf_valid(0) then
          return false
        end
        -- disable completion in comments
        local context = require("cmp.config.context")
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == "c" then
          return true
        else
          local cfg = require('editor').bufconfig(vim.api.nvim_get_current_buf(), true)
          local is_suggest_enabled = cfg.editor.quickSuggestions.other ~= "off"
          if not is_suggest_enabled then
            return false
          end
          local is_comment_suggest_enabled = not context.in_treesitter_capture("comment")
              and not context.in_syntax_group("Comment")
          return is_comment_suggest_enabled or cfg.editor.quickSuggestions.comments ~= "off"
        end
      end,
      performance = {
        debounce = (function()
          return vim.o.updatetime / 2
        end)(),
        throttle = (function()
          return vim.o.updatetime / 2
        end)(),
        max_view_entries = 25,
      },
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
            -- if vim.fn.mode() == 'o' then
            --   return false
            -- end
            return {
              require("cmp.types").cmp.TriggerEvent.InsertEnter,
              require("cmp.types").cmp.TriggerEvent.TextChanged,
            }
          else
            return false
          end
        end)(),
        keyword_length = 3,
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
        disallow_fuzzy_matching = (function()
          return not editorconfig.editor.suggest.filterGraceful
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
        ["<C-y>"] = cmp.mapping(function(fallback)
          local is_luasnip_present, luasnip = pcall(require, "luasnip")
          if cmp.visible() then
            if is_luasnip_present and luasnip.expandable() then
              luasnip.expand()
            else
              cmp.confirm({
                behavior = (function()
                  if editorconfig.editor.suggest.insertMode == "replace" then
                    return cmp.ConfirmBehavior.Replace
                  else
                    return cmp.ConfirmBehavior.Insert
                  end
                end)(),
                select = true,
              })
            end
          else
            fallback()
          end
        end),
        ["<Tab>"] = cmp.mapping(function(fallback)
          local is_luasnip_present, luasnip = pcall(require, "luasnip")
          if is_luasnip_present and luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          local is_luasnip_present, luasnip = pcall(require, "luasnip")
          if is_luasnip_present and luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          -- else
          --   fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          -- else
          --   fallback()
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
        local cmp_sources = {}
        table.insert(
          cmp_sources,
          {
            name = "nvim_lsp",
            keyword_length = 3,
            group_index = 1,
            entry_filter = function(entry, _)
              local kind = cmp.lsp.CompletionItemKind[entry:get_kind()]
              if kind == 'Text' then
                kind = 'Word'
              end
              local visible = editorconfig.editor.suggest['show' .. kind .. 's']
              if visible ~= nil and visible == false then
                return false
              end
              return true
            end
          }
        )
        table.insert(cmp_sources, { name = "nvim_lua", group_index = 2 })
        table.insert(cmp_sources, { name = "luasnip", group_index = 2 })
        local text_suggestions = editorconfig.editor.wordBasedSuggestions
        if text_suggestions and text_suggestions ~= 'off' then
          table.insert(cmp_sources, { name = "buffer", group_index = 3 })
        end
        if editorconfig.editor.suggest.showFiles == true then
          table.insert(cmp_sources, { name = "path", group_index = 4 })
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
