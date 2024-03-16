require 'core.unset'
require 'core.options'
require 'core.autocmds'
require 'core.keymaps'
require 'plugins.lazy'

local config = require 'utils.config'
vim.cmd.colorscheme(config.colorscheme)
