local config = require 'utils.config'

return {
  'williamboman/mason-lspconfig.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    ensure_installed = config.servers,
    automatic_installation = true,
  },
  dependencies = {
    'williamboman/mason.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':MasonUpdate',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonUpdate', 'MasonLog' },
    opts = {
      ui = {
        border = 'rounded',
        height = 0.8,
      },
      log_level = vim.log.levels.WARN,
      max_concurrent_installers = 4,
    },
  },
}
