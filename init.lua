if require 'dtsf.first_load'() then
  return
end

-- leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'dtsf.disable_builtins'
require 'dtsf.highlights'
require 'dtsf.options'
require 'dtsf.bindings'
require 'dtsf.plugins'
