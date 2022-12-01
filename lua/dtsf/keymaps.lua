local keymap = vim.keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap.set('n', 'x', '"_x', opts)

-- common actions (return to normal mode, quit, save, save and quit)
keymap.set('i', '<C-c>', '<Esc>', opts) -- get out of insert mode with <C-c> (yeah I know, but I can't avoid it)
keymap.set('n', '<leader>w', ':w<CR>', opts)
keymap.set('n', '<leader>q', ':q<CR>', opts)
keymap.set('n', '<leader>x', ':x<CR>', opts)
keymap.set('i', '<Tab>', '<Tab>', opts) -- something messing up with tab in insert mode, might be copilot and/or cmp

-- keep things centered when searching or joining lines
keymap.set('n', 'n', 'nzzzv', opts)
keymap.set('n', 'N', 'Nzzzv', opts)
keymap.set('n', 'J', 'mzJ`z', opts)

-- split screen
-- set keymaps to open split screen with terminal in it, also open terminal in current directory
keymap.set('n', '<leader>v', ':vsplit<CR>', opts)
keymap.set('n', '<leader>s', ':split<CR>', opts)
keymap.set('n', '<leader>q', ':q<CR>', opts)

-- resize windows
keymap.set('n', '<leader><left>', '<C-w><', opts)
keymap.set('n', '<leader><right>', '<C-w>>', opts)
keymap.set('n', '<leader><up>', '<C-w>+', opts)
keymap.set('n', '<leader><down>', '<C-w>-', opts)

-- source config
keymap.set('n', '<leader>.', ':luafile %<CR>', opts)

-- ThePrimeagen vim master keymaps
-- copy to clipboard / delete
keymap.set('n', '<space>y', '"+y', opts)
keymap.set('v', '<space>y', '"+y', opts)
keymap.set('n', '<space>d', '_d', opts)
keymap.set('v', '<space>d', '_d', opts)
keymap.set('n', '<leader>Y', 'gg"+yG', opts) -- copy all
keymap.set('n', '<leader>P', [["_diwP]]) -- keep pasting over the same thing
-- move lines
keymap.set('v', 'J', ":m '>+0<CR>gv=gv")
keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
keymap.set('n', '<leader>j', ':m .+1<CR>==', opts)
keymap.set('n', '<leader>k', ':m .-2<CR>==', opts)
-- harpoon
keymap.set('n', '<C-s>m', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', opts)
keymap.set('n', '<C-s>b', ':lua require("harpoon.mark").add_file()<CR>', opts)
keymap.set('n', '<C-s>k', ':lua require("harpoon.ui").nav_next()<CR>', opts)
keymap.set('n', '<C-s>j', ':lua require("harpoon.ui").nav_prev()<CR>', opts)

-- github copilot
keymap.set('n', '<leader>cp', ':Copilot panel<CR>', opts)
keymap.set('n', '<leader>ce', ':Copilot enable<CR>', opts)
keymap.set('n', '<leader>cd', ':Copilot disable<CR>', opts)
keymap.set('n', '<leader>cc', ':Copilot status<CR>', opts)

-- gitsigns null-ls code actions
keymap.set('n', '<leader>gs', ':lua vim.lsp.buf.code_action()<CR>', opts)

-- toggle wrap
keymap.set('n', '<A-z>', ':set wrap!<CR>', opts)
keymap.set('i', '<A-z>', '<esc> :set wrap!<CR>', opts)

-- indent lines in visual mode
keymap.set('v', '<', '<gv', opts)
keymap.set('v', '>', '>gv', opts)

-- comment.nvim
keymap.set('n', '<leader>/', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', opts)
keymap.set('v', '<leader>/', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts)
