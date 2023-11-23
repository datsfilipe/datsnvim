local ok, lsp_zero = pcall(require, 'lsp-zero')
if not ok then
  return
end

local custom_maps = require("core.keymaps.integrations.lsp")
lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(_, bufnr)
  custom_maps(bufnr)
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
