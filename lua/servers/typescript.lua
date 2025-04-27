local utils = require 'utils'
if not utils.is_bin_available ' typescript-language-server' then
  return
end

vim.lsp.config.typescript = {
  cmd = { 'typescript-language-server', '--stdio' },
  settings = {
    typescript = {
      server_capabilities = {
        documentFormattingProvider = false,
      },
    },
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  init_options = {
    hostInfo = 'neovim',
  },
}

vim.lsp.enable 'typescript'
