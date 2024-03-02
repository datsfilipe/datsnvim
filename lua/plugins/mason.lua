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
    config = function()
      if vim.fn.system("nixos-version") ~= "" then
        local mason_registry = require("mason-registry")
        local script_dir = os.getenv("HOME") .. "/.config/nvim/scripts/"

        mason_registry:on("package:install:success", function(pkg)
          patch_for_nixos(pkg)
        end)
      end

      require('mason').setup({
        ui = {
          border = 'rounded',
          height = 0.6,
        },
        log_level = vim.log.levels.WARN,
        max_concurrent_installers = 4,
      })
    end,
  },
}
