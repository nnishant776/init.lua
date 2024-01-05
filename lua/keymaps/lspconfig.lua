---@class KeymapOptions
---@field buffer integer|boolean Specifies if the keymap should be applied on a specific buffer
---@field desc string Additional description of the keymap
---@field expr boolean Specifies whether the action is an expression

---@class Keymap
---@field mode string|table
---@field input_keys string
---@field action string|function
---@field opts table

local M = {}

function M.setup(opts)
  opts = opts or {}

  ---@type Keymap[]
  local keymap = {
    {
      mode = { 'n' },
      input_keys = '<ESC>',
      action = function()
        vim.cmd([[ noh ]])
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.clear_references()
      end,
      opts = { desc = 'Clear highlights on pressing ESC' },
    },
    {
      mode = { 'n' },
      input_keys = "gD",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.declaration()
      end,
      opts = { desc = "List symbol declaration" },
    },
    {
      mode = { 'n' },
      input_keys = "gd",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.definition()
      end,
      opts = { desc = "List symbol definition" },
    },
    {
      mode = { 'n' },
      input_keys = "gi",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.implementation()
      end,
      opts = { desc = "List symbol implementation" },
    },
    {
      mode = { 'n' },
      input_keys = "gr",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.references()
      end,
      opts = { desc = "List references" },
    },
    {
      mode = { 'n' },
      input_keys = "[d",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.diagnostic.goto_prev()
      end,
      opts = { desc = "Goto previous diagnostic item" },
    },
    {
      mode = { 'n' },
      input_keys = "]d",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.diagnostic.goto_next()
      end,
      opts = { desc = "Goto next diagnostic item" },
    },
    {
      mode = { 'n' },
      input_keys = "K",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.hover()
      end,
      opts = { desc = "Show symbol hover" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>ldf",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.diagnostic.open_float()
      end,
      opts = { desc = "Show floating diagnostic" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lsH",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.signature_help()
      end,
      opts = { desc = "Show signature help" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lhs",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.document_highlight()
      end,
      opts = { desc = "Set reference highlight" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lhc",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.clear_references()
      end,
      opts = { desc = "Clear reference highlight" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lca",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.code_action()
      end,
      opts = { desc = "View code actions" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lfm",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.format({ async = true })
      end,
      opts = { desc = "Format document" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>wa",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.add_workspace_folder()
      end,
      opts = { desc = "Add workspace folder" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>wr",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.remove_workspace_folder()
      end,
      opts = { desc = "Remove workspace folder" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>wl",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.list_workspace_folders()
      end,
      opts = { desc = "List workspace folders" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lsW",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        local is_telescope_present, telescope = pcall(require, 'telescope.builtin')
        if is_telescope_present then
          telescope.lsp_dynamic_workspace_symbols()
        else
          vim.lsp.buf.workspace_symbol(nil, {})
        end
      end,
      opts = { desc = "List workspace symbols" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lsD",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        local is_telescope_present, telescope = pcall(require, 'telescope.builtin')
        if is_telescope_present then
          telescope.lsp_document_symbols()
        else
          vim.lsp.buf.document_symbol()
        end
      end,
      opts = { desc = "List document symbols" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lsr",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        local is_telescope_present, telescope = pcall(require, 'telescope.builtin')
        if is_telescope_present then
          telescope.lsp_references()
        else
          vim.lsp.buf.references(nil, {})
        end
      end,
      opts = { desc = "List symbol references" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lsd",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        local is_telescope_present, telescope = pcall(require, 'telescope.builtin')
        if is_telescope_present then
          telescope.lsp_definitions()
        else
          vim.lsp.buf.definition()
        end
      end,
      opts = { desc = "List symbol definitions" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lst",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        local is_telescope_present, telescope = pcall(require, 'telescope.builtin')
        if is_telescope_present then
          telescope.lsp_type_definitions()
        else
          vim.lsp.buf.type_definition()
        end
      end,
      opts = { desc = "List symbol type definitions" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lsi",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        local is_telescope_present, telescope = pcall(require, 'telescope.builtin')
        if is_telescope_present then
          telescope.lsp_implementations()
        else
          vim.lsp.buf.implementation()
        end
      end,
      opts = { desc = "List symbol implementations" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lsR",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        vim.lsp.buf.rename(nil, {})
      end,
      opts = { desc = "Rename symbol" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lci",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        local is_telescope_present, telescope = pcall(require, 'telescope.builtin')
        if is_telescope_present then
          telescope.lsp_incoming_calls()
        else
          vim.lsp.buf.incoming_calls()
        end
      end,
      opts = { desc = "List incoming calls" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lco",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        local is_telescope_present, telescope = pcall(require, 'telescope.builtin')
        if is_telescope_present then
          telescope.lsp_outgoing_calls()
        else
          vim.lsp.buf.outgoing_calls()
        end
      end,
      opts = { desc = "List outgoing calls" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>lD",
      action = function()
        local is_lsp_present, _ = pcall(require, 'lspconfig')
        if not is_lsp_present then
          return
        end
        local is_telescope_present, telescope = pcall(require, 'telescope.builtin')
        if is_telescope_present then
          telescope.diagnostics()
        else
          vim.diagnostic.setqflist()
        end
      end,
      opts = { desc = "List project diagnostics" },
    },
    {
      mode = { 'n' },
      input_keys = "<leader>tss",
      action = function()
        local is_treesitter_present, _ = pcall(require, 'nvim-treesitter.configs')
        if not is_treesitter_present then
          return
        end
        local is_telescope_present, telescope = pcall(require, 'telescope.builtin')
        if is_telescope_present then
          telescope.treesitter()
        end
      end,
      opts = { desc = "List tree-sitter symbols" },
    },
  }

  for _, km in ipairs(keymap) do
    km.opts = vim.tbl_deep_extend("keep", km.opts, opts)
    vim.keymap.set(km.mode, km.input_keys, km.action, km.opts)
  end
end

return M
