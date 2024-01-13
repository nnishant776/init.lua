local spec = {
  enabled = true,
  cond = true,
  opts = {},
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzf-native.nvim',
  },
}

local M = {}

local function get_grep_cmd()
  if vim.fn.executable('rg') == 1 then
    return {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    }
  else
    return {
      "grep",
      "-s",
      "-b",
      "-R",
      "--color=never",
      "--with-filename",
      "--line-number",
    }
  end
end

function M.is_enabled(profile, _)
  if profile.minimal or profile.default then
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
    defaults = {
      vimgrep_arguments = get_grep_cmd(),
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      initial_mode = "normal",
      preview = {
        filesize_limit = 0.1,
      },
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.60,
          results_width = 0.40,
        },
        vertical = {
          mirror = false,
        },
        width = 0.90,
        height = 0.80,
        preview_cutoff = 120,
      },
      file_ignore_patterns = (function()
        local ignore_patterns = {}
        for k in pairs(editorconfig.files.exclude) do
          table.insert(ignore_patterns, k)
        end
      end)(),
      path_display = { "truncate" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      extensions_list = { "themes", "terms" },
    },
  }
  spec.config = function(_, opts)
    local is_telescope_present, telescope = pcall(require, 'telescope')
    if not is_telescope_present then
      return
    end

    -- Setup plugin
    opts = opts or {}
    opts = vim.tbl_deep_extend('force', opts, {
      defaults = {
        buffer_previewer_maker = function(filepath, buf_id, preview_opts)
          preview_opts = preview_opts or {}
          preview_opts.use_ft_detect = false -- no highlighting in telescope perview
          filepath = vim.fn.expand(filepath)
          local Job = require('plenary.job')
          local previewers = require("telescope.previewers")
          if vim.fn.executable('file') == 0 then
            -- maybe we want to write something to the buffer here
            vim.schedule(function()
              vim.api.nvim_buf_set_lines(buf_id, 0, -1, false,
                { "Could not determin the mime type. Command 'file' not found" })
            end)
          else
            Job:new({
              command = "file",
              args = { "--mime-type", "-b", filepath },
              on_exit = function(j)
                local mime_type = vim.split(j:result()[1], "/")[1]
                if mime_type == "text" then
                  previewers.buffer_previewer_maker(filepath, buf_id, preview_opts)
                else
                  -- maybe we want to write something to the buffer here
                  vim.schedule(function()
                    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, { "BINARY" })
                  end)
                end
              end
            }):sync()
          end
        end,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        mappings = {
          n = { ["q"] = require('telescope.actions').close },
        },
      },
    })
    telescope.setup(opts)

    -- Setup plugin extension
    pcall(function()
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end)

    -- Setup keymap
    local is_telescope_keymap_present, keymap = pcall(require, 'keymaps.telescope')
    if not is_telescope_keymap_present then
      return
    end
    keymap.setup({})
  end
end

function M.spec()
  return spec
end

return M
