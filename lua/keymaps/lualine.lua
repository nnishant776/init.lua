local M = {}

function M.setup(opts)
  local keymap = {
    {
      mode = { 'n' },
      input_keys = ']b',
      action = function()
        vim.cmd("bnext")
      end,
      opts = {
        desc = "Jump to next buffer",
      },
    },
    {
      mode = { 'n' },
      input_keys = '[b',
      action = function()
        vim.cmd("bprevious")
      end,
      opts = {
        desc = "Jump to previous buffer",
      },
    },
    {
      mode = { 'n' },
      input_keys = ']t',
      action = function()
        vim.cmd("tabnext")
      end,
      opts = {
        desc = "Jump to next buffer",
      },
    },
    {
      mode = { 'n' },
      input_keys = '[t',
      action = function()
        vim.cmd("tabprevious")
      end,
      opts = {
        desc = "Jump to previous buffer",
      },
    },
  }

  for _, km in ipairs(keymap) do
    km.opts = vim.tbl_deep_extend("keep", km.opts, opts)
    vim.keymap.set(km.mode, km.input_keys, km.action, km.opts)
  end
end

return M
