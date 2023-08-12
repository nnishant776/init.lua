return {
  statusline = {
    separator_style = "block",
    overriden_modules = function()
      return {
        cwd = function()
          return ""
        end,
        cursor_position = function()
          local sep_style = vim.g.statusline_sep_style
          local separators = (type(sep_style) == "table" and sep_style)
              or require("nvchad_ui.icons").statusline_separators[sep_style]
          local sep_l = separators["left"]
          -- local sep_r = separators["right"]

          local left_sep = "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#" .. " "
          local text = ""
          local cursor_pos = ""

          if vim.g.config.editor.showPosition then
            local r, c = unpack(vim.api.nvim_win_get_cursor(0))
            local total_line = vim.fn.line("$")
            text = string.format("%3d", math.modf((r / total_line) * 100)) .. tostring("%%") .. " "
            cursor_pos = " " .. string.format("%10s", string.format("%d,%d", r, c)) .. " "
          end

          return left_sep .. "%#St_pos_text#" .. cursor_pos .. text
        end,
      }
    end,
    tabufline = {
      enabled = true,
      lazyload = false,
      overriden_modules = nil,
    },
  }
}

-- dir path relative to project
-- vim.fn.fnamemodify(vim.fn.expand('%:h'), ':p:~:.')
