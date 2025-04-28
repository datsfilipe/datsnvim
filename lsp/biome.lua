local utils = require 'utils'
if not utils.is_bin_available 'biome' then
  return
end

return {
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
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_files = { 'biome.json', 'biome.jsonc' }
    root_files = utils.insert_package_json(root_files, 'biome', fname)
    local root_dir = vim.fs.dirname(
      vim.fs.find(root_files, { path = fname, upward = true })[1]
    )
    on_dir(root_dir)
  end,
}
