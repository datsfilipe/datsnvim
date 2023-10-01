local ok, mason = pcall(require, "mason")
if not ok then
  return
end

mason.setup({})

local lsp_zero = require("lsp-zero")

require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})