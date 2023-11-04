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

local theme = require("core/colorscheme")

require("lazy").setup {
  -- the following option is set here because I'm using nixos
  -- and editing nvim config from another place, not the usual
  lockfile = vim.fn.expand("$HOME/.dotfiles/modules/nvim") .. "/lazy-lock.json",
  install = {
    missing = true,
    colorscheme = { theme },
  },
  spec = {
    { import = "modules.plugins.spec" },
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
      task = "",
    },
  },
}