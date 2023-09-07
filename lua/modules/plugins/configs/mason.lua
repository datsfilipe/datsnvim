local ok, lspconfig = pcall(require, "mason-lspconfig")
if not ok then
  return
end

lspconfig.setup {
  ensure_installed = {
    "rust_analyzer",
    "tsserver",
    "lua_ls",
  },
}