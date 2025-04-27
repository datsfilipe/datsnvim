local utils = require 'utils'
if not utils.is_bin_available 'vscode-eslint-language-server' then
  return
end

vim.lsp.config.eslint = {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
    'svelte',
    'astro',
  },
  settings = { format = true },
}

vim.lsp.enable 'eslint'
