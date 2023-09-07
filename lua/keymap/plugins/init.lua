local map = require('keymap.helper').map
local opts = { noremap = true, silent = true }

-- comment
map { 'n', '<leader>/', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', opts }
map { 'v', '<leader>/', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts }

-- diffview
map { 'n', '<leader>gd', ':DiffviewOpen<CR>', opts }
map { 'n', '<leader>gc', ':DiffviewClose<CR>', opts }
map { 'n', '<leader>ge', ':DiffviewToggleFiles<CR>', opts }
map { 'n', '<leader>gr', ':DiffviewRefresh<CR>', opts }
map { 'n', '<leader>gs', ':DiffviewToggleFiles<CR>', opts }

-- neogit
map { 'n', '<leader>gg', '<cmd>Neogit<CR>', opts }

-- markdown preview
map { 'n', '<F12>', '<cmd>MarkdownPreviewToggle<CR>', opts }