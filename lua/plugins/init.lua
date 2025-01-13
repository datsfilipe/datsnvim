local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp = vim.opt.rtp ^ lazypath

local nix = require 'nix'
local plugins = require 'extensions.specs.default'
local colorscheme = nix.colorscheme or 'vesper'

require('lazy').setup {
  lockfile = nix.lockfile or vim.fn.stdpath 'config' .. '/lazy-lock.json',
  spec = plugins.spec,
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { colorscheme },
    missing = false,
  },
  change_detection = { notify = false },
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'netrw',
        'matchit',
        'matchparen',
        'vimball',
        'vimballPlugin',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  ui = {
    border = 'none',
    backdrop = 90,
    icons = require('icons').lazy_icons,
  },
}
