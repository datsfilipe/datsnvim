local map = require('keymap.helper').map

map { 'n', '<leader>x', '<cmd>!chmod +x %<CR>', opts } -- make file executable
map { 'n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>' }