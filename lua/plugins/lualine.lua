local spec = {
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {},
}

local M = {}

function M.is_enabled(profile, _)
  if profile.minimal then
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
  spec.opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = "│", right = "│" },
      section_separators = { left = "│", right = "│" },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = {
        { 'mode', draw_empty = false, padding = 1 }
      },
      lualine_b = {
        { 'branch', draw_empty = false, padding = 1 },
        {
          'diff',
          draw_empty = false,
          padding = 1,
          colored = true,
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.modified,
                removed = gitsigns.removed,
              }
            end
          end,
        },
        {
          'diagnostics',
          draw_empty = false,
          padding = 1,
          sources = { 'nvim_diagnostic' },
          sections = { 'error', 'warn', 'info', 'hint' },
          diagnostics_color = {
            error = 'DiagnosticError',
            warn  = 'DiagnosticWarn',
            info  = 'DiagnosticInfo',
            hint  = 'DiagnosticHint',
          },
          -- symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
          colored = true,
          update_in_insert = false,
          always_visible = false,
        },
      },
      lualine_c = {
        {
          'filename',
          draw_empty = false,
          padding = 1,
          path = (function()
            if editorconfig.window.filename == 'base' then
              return 0
            elseif editorconfig.window.filename == 'rootrel' then
              return 1
            else
              return 3
            end
          end)(),
        },
      },
      lualine_x = {
        { 'encoding',   draw_empty = false, padding = 1 },
        { 'fileformat', draw_empty = false, padding = 1 },
        { 'filetype',   draw_empty = false, padding = 1 },
      },
      lualine_y = {
        {
          'progress',
          draw_empty = false,
          padding = 1,
          cond = function()
            return editorconfig.editor.showPosition
          end,
        },
      },
      lualine_z = {
        {
          'location',
          draw_empty = false,
          padding = 1,
          cond = function()
            return editorconfig.editor.showPosition
          end,
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {
      lualine_a = {
        {
          'buffers',
          show_filename_only = true,
          hide_filename_extension = false,
          show_modified_status = true,
          mode = 2,
          max_length = vim.o.columns * 2 / 3,
          use_mode_colors = false,
          symbols = {
            modified = ' ●',
            alternate_file = '#',
            directory = '',
          },
        },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        {
          'tabs',
          mode = 1,
          path = 0,
        },
      },
    },
    extensions = {
      'symbols-outline',
      'quickfix',
    }
  }
  spec.config = function(_, opts)
    opts = opts or {}
    local is_lualine_present, lualine = pcall(require, 'lualine')
    if not is_lualine_present then
      return
    end
    lualine.setup(opts)
    local is_lualine_keymap_present, keymap = pcall(require, 'keymaps.lualine')
    if not is_lualine_keymap_present then
      return
    end
    keymap.setup({})
  end
end

function M.spec()
  return spec
end

return M
