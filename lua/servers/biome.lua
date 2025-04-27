local utils = require 'utils'
if not utils.is_bin_available 'biome' then
  return
end

vim.lsp.config.biome = {
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = {
    'astro',
    'css',
    'graphql',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
    'vue',
  },
}

vim.lsp.enable 'biome'
