local utils = require 'utils'
if not utils.is_bin_available 'vscode-eslint-language-server' then
  return
end

return {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  workspace_required = true,
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
  settings = {
    validate = 'on',
    packageManager = nil,
    useESLintClass = false,
    experimental = {
      useFlatConfig = false,
    },
    codeActionOnSave = {
      enable = false,
      mode = 'all',
    },
    format = true,
    quiet = false,
    onIgnoredFiles = 'off',
    rulesCustomizations = {},
    run = 'onType',
    problems = {
      shortenToSingleLine = false,
    },
    nodePath = '',
    workingDirectory = { mode = 'location' },
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
    },
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
    on_dir(
      vim.fs.dirname(
        vim.fs.find(root_file_patterns, { path = fname, upward = true })[1]
      )
    )
  end,
  before_init = function(_, config)
    local root_dir = config.root_dir

    if root_dir then
      config.settings = config.settings or {}
      config.settings.workspaceFolder = {
        uri = root_dir,
        name = vim.fn.fnamemodify(root_dir, ':t'),
      }

      local flat_config_files = {
        'eslint.config.js',
        'eslint.config.mjs',
        'eslint.config.cjs',
        'eslint.config.ts',
        'eslint.config.mts',
        'eslint.config.cts',
      }

      for _, file in ipairs(flat_config_files) do
        if vim.fn.filereadable(root_dir .. '/' .. file) == 1 then
          config.settings.experimental = config.settings.experimental or {}
          config.settings.experimental.useFlatConfig = true
          break
        end
      end

      local pnp_cjs = root_dir .. '/.pnp.cjs'
      local pnp_js = root_dir .. '/.pnp.js'
      if vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js) then
        local cmd = config.cmd
        config.cmd = vim.list_extend({ 'yarn', 'exec' }, cmd)
      end
    end
  end,
}
