return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    event = "BufEnter",
    config = function()
      local lsp_zero = require "lsp-zero"

      local keymap = vim.keymap

      lsp_zero.extend_lspconfig()
      lsp_zero.on_attach(function(_, bufnr)
        local opts = { buffer = bufnr, remap = false }

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
      end)

      -- diagnostics
      vim.diagnostic.config {
        virtual_text = {
          prefix = "●",
          spacing = 0,
        },
      }

      vim.cmd [[
        sign define DiagnosticSignError text=● texthl=DiagnosticSignError linehl= numhl=
        sign define DiagnosticSignWarn text=● texthl=DiagnosticSignWarn linehl= numhl=
        sign define DiagnosticSignInfo text=● texthl=DiagnosticSignInfo linehl= numhl=
        sign define DiagnosticSignHint text=● texthl=DiagnosticSignHint linehl= numhl=
      ]]
    end
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
  },
}
