-- leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if require 'dtsf.packer.auto_install'() then
  return
end

require 'dtsf.disable_builtins'
require 'dtsf.options'
require 'dtsf.highlights'
require 'dtsf.bindings'
require 'dtsf.packer.plugins'
require 'dtsf.telescope'
