local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- nixos compatibility:
-- set colorscheme and lockfile path with nixos, so it will change with your nixos config
local colorscheme = require("utils/colorscheme")
local get_lockfile_path = function()
  local ok, nixos_path = pcall(require, "utils/_nixos_lazylock_path")
  if ok then return nixos_path end
  return nil
end

require("lazy").setup {
  lockfile = vim.fn.expand(get_lockfile_path()) .. "/lazy-lock.json" or vim.fn.stdpath("config") .. "/lazy-lock.json",
  install = {
    missing = true,
    colorscheme = { colorscheme },
  },
  spec = "plugins._lazy_spec",
  defaults = {
    lazy = false,
    version = false,
  },
  checker = {
    enabled = true,
    notify = true,
  },
  ui = {
    icons = {
      task = "",
    },
  },
}
