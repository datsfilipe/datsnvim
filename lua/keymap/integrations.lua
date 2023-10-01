local map = require("scripts.map")

local opts = { noremap = true, silent = true }

map { "n", "<leader>x", "<cmd>!chmod +x %<CR>", opts } -- make file executable
map { "n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>" }

-- gh
map { "n", "<leader>pr", "<cmd>lua require('scripts.create_pr').create()<CR>", opts }