local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- nixos compatibility:
-- set colorscheme and lockfile path with nixos, so it will change with your nixos config
local config = require 'utils/config'

require('lazy').setup {
  lockfile = config.lockfile,
  install = {
    missing = true,
    colorscheme = { config.colorscheme },
  },
  spec = 'plugins',
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
      task = '',
    },
  },
}
