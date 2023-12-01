local servers = require "utils.config".servers

return {
  "williamboman/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    ensure_installed = servers,
    automatic_installation = true,
  },
  dependencies = {
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonUpdate", "MasonLog" },
    opts = {
      ui = {
        border = "rounded",
        height = 0.8,
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
    },
  },
}
