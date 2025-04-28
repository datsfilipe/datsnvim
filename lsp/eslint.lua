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
  root_dir = function(bufnr, on_dir)
    local root_file_patterns = {
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.yaml',
      '.eslintrc.yml',
      '.eslintrc.json',
      'eslint.config.js',
      'eslint.config.mjs',
      'eslint.config.cjs',
      'eslint.config.ts',
      'eslint.config.mts',
      'eslint.config.cts',
    }

    local fname = vim.api.nvim_buf_get_name(bufnr)
    root_file_patterns =
      utils.insert_package_json(root_file_patterns, 'eslintConfig', fname)
    local root_dir = vim.fs.dirname(
      vim.fs.find(root_file_patterns, { path = fname, upward = true })[1]
    )
    on_dir(root_dir)
  end,
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
    },
    codeActionOnSave = {
      enable = false,
      mode = 'all',
    },
    experimental = {
      useFlatConfig = false,
    },
    format = true,
    nodePath = '',
    onIgnoredFiles = 'off',
    problems = {
      shortenToSingleLine = false,
    },
    quiet = false,
    rulesCustomizations = {},
    run = 'onType',
    useESLintClass = false,
    validate = 'on',
    workingDirectory = {
      mode = 'location',
    },
  },
}
