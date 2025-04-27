local utils = require 'utils'
if not utils.is_bin_available 'vscode-eslint-language-server' then
  return
end

return {
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
