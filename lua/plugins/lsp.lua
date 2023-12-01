local keymap = vim.keymap
local config = require "utils.config"

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "folke/neodev.nvim",
  },
  event = "BufReadPre",
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Setting up on_attach
    local on_attach = function(client, bufnr)
      local opts = { silent = true, buffer = bufnr }

      keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
      end, opts)

      keymap.set("n", "<leader>vws", function()
        vim.lsp.buf.workspace_symbol()
      end, opts)

      keymap.set("n", "<leader>vd", function()
        vim.diagnostic.open_float()
      end, opts)

      keymap.set("n", "<leader>n", function()
        vim.diagnostic.goto_next()
      end, opts)

      keymap.set("n", "<leader>p", function()
        vim.diagnostic.goto_prev()
      end, opts)

      keymap.set("n", "<leader>vca", function()
        vim.lsp.buf.code_action()
      end, opts)

      keymap.set("n", "<leader>vrr", function()
        vim.lsp.buf.references()
      end, opts)

      keymap.set("n", "<leader>vrn", function()
        vim.lsp.buf.rename()
      end, opts)

      keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
      end, opts)

      keymap.set("n", "K", function()
        vim.lsp.buf.hover()
      end, opts)

      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
      keymap.set("n", "gD", "<cmd>Telescope lsp_type_definitions<CR>", opts)
      keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
      keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
      keymap.set("n", "<leader>ld", "<cmd>Telescope diagnostics<cr>", opts)

      -- tsserver specific
      if client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
      end
    end

    -- setup servers
    for _, server in pairs(config.servers) do
      Opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      server = vim.split(server, "@")[1]
      lspconfig[server].setup(Opts)
    end

    -- setup up border for LspInfo
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- setup icons for diagnostics
    local signs = {
      { name = "DiagnosticSignError", text = config.signs.Error },
      { name = "DiagnosticSignWarn",  text = config.signs.Warn },
      { name = "DiagnosticSignHint",  text = config.signs.Hint },
      { name = "DiagnosticSignInfo",  text = config.signs.Info },
    }
    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    vim.diagnostic.config({
      virtual_text = true,
      signs = {
        active = signs,
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        suffix = "",
      },
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })
    -- Setting up lua server
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end,
}
