require('nvim-treesitter').setup {
  ensure_installed = {
    'bash',
    'fish',
    'gitcommit',
    'graphql',
    'html',
    'json',
    'json5',
    'jsonc',
    'lua',
    'markdown',
    'markdown_inline',
    'regex',
    'scss',
    'toml',
    'tsx',
    'javascript',
    'typescript',
    'yaml',
  },
  highlight = { enable = true },
  incremental_selection = { enable = false },
  indent = {
    enable = true,
    disable = { 'yaml' },
  },
}

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Handle nvim-treesitter updates',
  group = vim.api.nvim_create_augroup(
    'nvim-treesitter-pack-changed-update-handler',
    { clear = true }
  ),
  callback = function(event)
    if event.data.kind == 'update' then
      vim.notify(
        'nvim-treesitter updated, running TSUpdate...',
        vim.log.levels.INFO
      )
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, 'TSUpdate')
      if ok then
        vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
      else
        vim.notify(
          'TSUpdate command not available yet, skipping',
          vim.log.levels.WARN
        )
      end
    end
  end,
})
