local M = {}

function M.setup(opts)
  opts = opts or {}

  ---@type Keymap[]
  local keymap = {
    -- Navigation through hunks
    {
      mode = { 'n' },
      input_keys = "]c",
      action = function()
        local is_gitsigns_present, gitsigns = pcall(require, 'gitsigns')
        if not is_gitsigns_present then
          return
        end
        vim.schedule(function()
          gitsigns.nav_hunk('next')
        end)
      end,
      opts = {
        desc = "Jump to next change",
      },
    },
    {
      mode = { 'n' },
      input_keys = "[c",
      action = function()
        local is_gitsigns_present, gitsigns = pcall(require, 'gitsigns')
        if not is_gitsigns_present then
          return
        end
        vim.schedule(function()
          gitsigns.nav_hunk('prev')
        end)
      end,
      opts = {
        desc = "Jump to previous change",
      },
    },

    -- Actions
    {
      mode = { 'n' },
      input_keys = "<leader>ghr",
      action = function()
        local is_gitsigns_present, gitsigns = pcall(require, 'gitsigns')
        if not is_gitsigns_present then
          return
        end
        gitsigns.reset_hunk()
      end,
      opts = {
        desc = "Reset hunk",
      },
    },
    {
      mode = { 'n', 'v' },
      input_keys = "<leader>ghs",
      action = function()
        local is_gitsigns_present, gitsigns = pcall(require, 'gitsigns')
        if not is_gitsigns_present then
          return
        end
        local range = require('utils.editor').get_selection_line_range()
        if range ~= nil then
          gitsigns.stage_hunk(range)
        else
          gitsigns.stage_hunk()
        end
      end,
      opts = {
        desc = "Stage hunk",
      },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>ghu",
      action = function()
        local is_gitsigns_present, gitsigns = pcall(require, 'gitsigns')
        if not is_gitsigns_present then
          return
        end
        gitsigns.undo_stage_hunk()
      end,
      opts = {
        desc = "Undo stage hunk",
      },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>ghp",
      action = function()
        local is_gitsigns_present, gitsigns = pcall(require, 'gitsigns')
        if not is_gitsigns_present then
          return
        end
        gitsigns.preview_hunk()
      end,
      opts = {
        desc = "Preview hunk",
      },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>gsb",
      action = function()
        local is_gitsigns_present, gitsigns = pcall(require, 'gitsigns')
        if not is_gitsigns_present then
          return
        end
        gitsigns.blame_line()
      end,
      opts = {
        desc = "Blame line",
      },
    },
    {
      mode = { 'n', 'v' },
      input_keys = "<leader>gshl",
      action = function()
        local line1
        local line2
        local range = require('utils.editor').get_selection_line_range()
        if range == nil then
          line1 = vim.fn.line('.')
          line2 = line1
        else
          line1, line2 = range[1], range[2]
        end
        local filename = require('utils.editor').get_relative_file_path()
        vim.cmd("Git log --format='%h (%an) %s' -s -L" .. string.format("%d,%d", line1, line2) .. ":" .. filename)
      end,
      opts = {
        desc = "Show line history",
      },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>gshf",
      action = function()
        local filename = require('utils.editor').get_relative_file_path()
        vim.cmd("Git log --format='%h (%an) %s' -s --follow " .. filename)
      end,
      opts = {
        desc = "Show file history",
      },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>gtd",
      action = function()
        local is_gitsigns_present, gitsigns = pcall(require, 'gitsigns')
        if not is_gitsigns_present then
          return
        end
        gitsigns.toggle_deleted()
      end,
      opts = {
        desc = "Toggle deleted changes",
      },
    },
  }

  for _, km in ipairs(keymap) do
    km.opts = vim.tbl_deep_extend("keep", km.opts, opts)
    vim.keymap.set(km.mode, km.input_keys, km.action, km.opts)
  end
end

return M
