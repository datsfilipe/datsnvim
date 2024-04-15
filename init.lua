require 'core.unset'
require 'core.options'
require 'core.autocmds'
require 'core.keymaps'
require 'plugins.lazy'

local config = require 'core.config'
vim.cmd.colorscheme(config.colorscheme)
