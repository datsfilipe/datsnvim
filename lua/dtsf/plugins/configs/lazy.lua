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

require('lazy').setup {
  install = {
    missing = true,
    colorscheme = { 'oxocarbon' },
  },
  spec = {
    { import = 'dtsf.plugins' },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = { enabled = true },
  ui = {
    icons = {
      task = '',
    },
  },
}
