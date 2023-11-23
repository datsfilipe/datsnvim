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
local colorscheme = require("utils/config").colorscheme
local lockfile = require("utils/config").lockfile

require("lazy").setup {
  lockfile = lockfile,
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
