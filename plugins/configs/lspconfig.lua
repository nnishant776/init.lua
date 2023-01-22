local lspconfig_present, lspconfig = pcall(require, "lspconfig")

if not lspconfig_present then
  return
end

local cmp_present, cmp = pcall(require, "cmp")
local cmp_nvim_lsp_present, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

require("base46").load_highlight "lsp"
require "nvchad_ui.lsp"

local M = {}
local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad_ui.signature").setup(client)
  end

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_buf_create_user_command(bufnr, "LspSetHighlight", function()
      vim.lsp.buf.document_highlight()
    end, {})
    vim.api.nvim_buf_create_user_command(bufnr, "LspClearHighlight", function()
      vim.lsp.buf.clear_references()
    end, {})
  end
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_augroup("LspAutoFormat", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        -- if vim.g.enableautoformat then
        vim.lsp.buf.format({})
        -- end
      end,
      buffer = bufnr,
      group = "LspAutoFormat",
      desc = "Document Format",
    })
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_nvim_lsp_present then
  M.capabilities = cmp_nvim_lsp.default_capabilities()
end

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = false,
  preselectSupport = false,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

lspconfig.sumneko_lua.setup {
  on_attach = function(client, bufnr)
    M.on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "shiftwidth", 2)
    vim.api.nvim_buf_set_option(bufnr, "tabstop", 2)
    vim.api.nvim_buf_set_option(bufnr, "softtabstop", 2)
    vim.api.nvim_buf_set_option(bufnr, "expandtab", true)
  end,

  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

-- lspconfig.gopls.setup {
--   settings = {
--     gopls = {
--       experimentalPostfixCompletions = false,
--       analyses = {
--         shadow = true,
--         fieldalignment = true,
--         unsed = true,
--         all = true,
--         ST1003 = false,
--         ST1006 = false,
--         ST1020 = false,
--         ST1021 = false,
--         ST1022 = false,
--         ST1023 = false,
--         QF1011 = false,
--       },
--       staticcheck = true,
--       linksInHover = false,
--     },
--   },
--   on_attach = function(client, bufnr)
--     M.on_attach(client, bufnr)
--     vim.api.nvim_buf_set_option(bufnr, "shiftwidth", 8)
--     vim.api.nvim_buf_set_option(bufnr, "tabstop", 8)
--     vim.api.nvim_buf_set_option(bufnr, "softtabstop", 8)
--     vim.api.nvim_buf_set_option(bufnr, "expandtab", false)
--   end,
--   capabilities = M.capabilities,
-- }

-- lspconfig.clangd.setup {
--   on_attach = M.on_attach,
--   capabilities = M.capabilities,
-- }
--
-- lspconfig.pyright.setup {
--   on_attach = M.on_attach,
--   capabilities = M.capabilities,
-- }
--
-- lspconfig.rust_analyzer.setup {
--   on_attach = M.on_attach,
--   capabilities = M.capabilities,
-- }

return M
