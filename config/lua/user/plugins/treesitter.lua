local M = {}

function M.setup()
  if M._loaded then
    return
  end
  M._loaded = true

  local parser_dir = vim.fn.stdpath 'data' .. '/treesitter'
  vim.opt.runtimepath:prepend(parser_dir)

  pcall(vim.cmd, 'packadd nvim-treesitter')

  local ok, ts = pcall(require, 'nvim-treesitter.configs')
  if not ok then
    vim.notify('nvim-treesitter not available: ' .. tostring(ts), vim.log.levels.WARN)
    return
  end

  ts.setup {
    parser_install_dir = parser_dir,
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
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<cr>',
        node_incremental = '<cr>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },
  }
end

return M
