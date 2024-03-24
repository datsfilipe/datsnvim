local config = require 'utils.config'
local patch_for_nixos = require 'utils.patch_mason_binaries'.patch

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
    opts = function()
      if vim.fn.system('nixos-version') ~= '' then
        local mason_registry = require('mason-registry')

        mason_registry:on('package:install:success', function(pkg)
          patch_for_nixos(pkg)
        end)
      end

      return {
        ui = {
          border = 'rounded',
          height = 0.8,
        },
        log_level = vim.log.levels.WARN,
        max_concurrent_installers = 4,
      }
    end,
  },
}
