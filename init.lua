require 'dtsf.base'
require 'dtsf.highlights'
require 'dtsf.keymaps'
require 'dtsf.plugins'

-- it will disable copilot on startup and avoid the delay of autocmd approach
vim.g.copilot_enabled = 0
-- this will allow me to enable it iven if Tab key is used for comp.nvim
vim.g.copilot_assume_mapped = 1
