local M = {}

function M.setup(opts)
  local keymap = {
    {
      mode = { 'n' },
      input_keys = "<C-n>",
      action = function()
        local is_neotree_present, _ = pcall(require, 'neo-tree')
        if not is_neotree_present then
          return
        end
        vim.cmd("Neotree toggle")
      end,
      opts = { desc = "Toggle Neotree explorer" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>nfs",
      action = function()
        local is_neotree_present, _ = pcall(require, 'neo-tree')
        if not is_neotree_present then
          return
        end
        vim.cmd("Neotree toggle filesystem left")
      end,
      opts = { desc = "Toggle Neotree file explorer" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>nds",
      action = function()
        local is_neotree_present, _ = pcall(require, 'neo-tree')
        if not is_neotree_present then
          return
        end
        vim.cmd("Neotree toggle document_symbols left")
      end,
      opts = { desc = "Toggle Neotree symbol explorer" },
    },
  }

  for _, km in ipairs(keymap) do
    km.opts = vim.tbl_deep_extend("keep", km.opts, opts)
    vim.keymap.set(km.mode, km.input_keys, km.action, km.opts)
  end
end

return M
