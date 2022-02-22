local status_ok, _ = pcall(require, 'lspconfig')
if not status_ok then
  return
end

require 'dtsf.pconf.lsp.lsp-installer'
require('dtsf.pconf.lsp.handlers').setup()
require 'dtsf.pconf.lsp.null-ls'
