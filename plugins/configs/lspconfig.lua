local lspconfig_present, lspconfig = pcall(require, "lspconfig")
if not lspconfig_present then
  return
end

local lsp_config_present, lsp_config = pcall(require, "lspconfig/configs")

local cmp_present, cmp = pcall(require, "cmp")
local cmp_nvim_lsp_present, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

require("base46").load_highlight "lsp"
require "nvchad_ui.lsp"

local M = {}
local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  -- vim.diagnostic.reset()

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
        if vim.g.config.editor.formatOnSave then
          vim.lsp.buf.format({})
        end
      end,
      buffer = bufnr,
      group = "LspAutoFormat",
      desc = "Document Format",
    })

    vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function()
      if vim.fn.mode() == "v" then
        if client.server.documentRangeFormattingProvider then
          vim.lsp.buf.format({ range = {} })
        end
      else
        vim.lsp.buf.format({})
      end
    end, {})
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

if vim.g.config.editor.suggest.enabled then
  if not lsp_config.golangcilsp then
    lsp_config.golangcilsp = {
      default_config = {
        cmd = { 'golangci-lint-langserver' },
        root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
        init_options = {
          command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json",
            "--issues-exit-code=1" },
        }
      },
    }
  end

  lspconfig.lua_ls.setup {
    on_attach = M.on_attach,
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
  --         nilness = true,
  --         unusedparams = true,
  --         unusedwrite = true,
  --         unusedvariable = true,
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
  --   on_attach = M.on_attach,
  --   capabilities = M.capabilities,
  -- }

  -- lspconfig.golangci_lint_ls.setup {
  --   filetypes = { 'go', 'gomod' }
  -- }

  -- lspconfig.clangd.setup {
  --   on_attach = M.on_attach,
  --   capabilities = M.capabilities,
  -- }

  lspconfig.pyright.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
  }

  -- lspconfig.zls.setup {
  --   on_attach = M.on_attach,
  --   capabilities = M.capabilities,
  -- }

  -- lspconfig.pylsp.setup {
  --   configurationSources = "flake8"
  -- }

  -- lspconfig.rust_analyzer.setup {
  --   on_attach = M.on_attach,
  --   capabilities = M.capabilities,
  -- }
end

return M
