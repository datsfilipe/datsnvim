require "core.unset"
require "core.options"
require "core.autocmds"
require "core.keymaps"
require "utils.lazy"

local colorscheme = require "utils.config".colorscheme
vim.cmd.colorscheme(colorscheme)
