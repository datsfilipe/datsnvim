local map = require("core.utils").map

local opts = { noremap = true, silent = true }

map { "n", "<leader>x", "<cmd>!chmod +x %<CR>", opts } -- make file executable
map { "n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>" }