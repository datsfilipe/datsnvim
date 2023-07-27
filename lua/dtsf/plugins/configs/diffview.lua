local present, diffview = pcall(require, 'diffview')
if not present then
  return
end

diffview.setup {
  file_panel = {
    win_config = {
      width = 35,
    },
  },
  key_bindings = {
    disable_defaults = false,
  },
}

local nmap = require 'dtsf.utils'.nmap
local opts = { noremap = true, silent = true }

nmap { '<leader>gd', ':DiffviewOpen<CR>', opts }
nmap { '<leader>gc', ':DiffviewClose<CR>', opts }
nmap { '<leader>ge', ':DiffviewToggleFiles<CR>', opts }
nmap { '<leader>gr', ':DiffviewRefresh<CR>', opts }
nmap { '<leader>gs', ':DiffviewToggleFiles<CR>', opts }