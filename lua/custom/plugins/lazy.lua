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
local config = require 'utils.config'
local nix = require 'external.nix'

require('lazy').setup {
  lockfile = nix.lockfile or vim.fn.stdpath 'config' .. '/lazy-lock.json',
  install = {
    missing = true,
    colorscheme = { config.colorscheme },
  },
  spec = {
    { import = 'custom.plugins.ui' },
    { import = 'custom.plugins.code' },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  ui = {
    icons = {
      cmd = '[cmd]',
      config = '[conf]',
      event = '[evnt]',
      favorite = '[fav]',
      ft = '[ft]',
      init = '[init]',
      import = '[imp]',
      keys = '[key]',
      lazy = '[lazy]',
      loaded = '[x]',
      not_loaded = '[ ]',
      plugin = '[plug]',
      runtime = '[runtime]',
      require = '[req]',
      source = '[src]',
      start = '[start]',
      task = '[done]',
      list = {
        '*',
        '->',
        '+',
        '-',
      },
    },
  },
  performance = {
    cache = {
      enabled = true,
    },
  },
}
