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
          "marksman",
          "rust_analyzer",
          "tailwindcss",
          "tsserver",
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        }
      })
    end,
    dependencies = { "williamboman/mason-lspconfig.nvim" },
  },
}
