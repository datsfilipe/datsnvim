return {
  {
    "williamboman/mason.nvim",
    event = "BufEnter",
    build = ":MasonUpdate",
    config = function()
      local lsp_zero = require("lsp-zero")

      require "mason".setup {
        PATH = "append",
      }

      require('mason-lspconfig').setup({
        ensure_installed = {
          "lua_ls",
          "gopls",
          "elixirls",
          "tsserver",
          "marksman",
          "rust_analyzer",
          "tailwindcss",
        },
        handlers = {
          lsp_zero.default_setup,
        }
      })
    end,
    dependencies = { "williamboman/mason-lspconfig.nvim" },
  },
}
