local M = {}

function M.setup(opts)
  local keymap = {
    {
      mode = { 'n' },
      input_keys = "<leader>T",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope")
      end,
      opts = { desc = "Open Telescope" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>ff",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope find_files")
      end,
      opts = { desc = "Find files" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>fa",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope find_files follow=true no_ignore=true hidden=true")
      end,
      opts = { desc = "Find all" }
    },
    {
      mode = { 'n' },
      input_keys = "<leader>fw",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope live_grep")
      end,
      opts = { desc = "Find word (live)" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>fs",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope grep_string")
      end,
      opts = { desc = "Find word (static)" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>bl",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope buffers")
      end,
      opts = { desc = "List buffers" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>ht",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope help_tags")
      end,
      opts = { desc = "Show help tags" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>hk",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope keymaps")
      end,
      opts = { desc = "Show keymaps" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>gsc",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope git_commits")
      end,
      opts = { desc = "Show git commits" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>gss",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope git_status")
      end,
      opts = { desc = "Show git status" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>gsf",
      action = function()
        local is_telescope_present, _ = pcall(require, 'telescope')
        if not is_telescope_present then
          return
        end
        vim.cmd("Telescope git_files")
      end,
      opts = { desc = "Show git files" },
    },
  }

  for _, km in ipairs(keymap) do
    km.opts = vim.tbl_deep_extend("keep", km.opts, opts)
    vim.keymap.set(km.mode, km.input_keys, km.action, km.opts)
  end
end

return M
