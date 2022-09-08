local keymap = vim.keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap.set('n', 'x', '"_x', opts)

-- get out insert mode with <C-c>
keymap.set('i', '<C-c>', '<esc>', opts)

-- keep things centered when searching or joining lines
keymap.set('n', 'n', 'nzzzv', opts)
keymap.set('n', 'N', 'Nzzzv', opts)
keymap.set('n', 'J', 'mzJ`z', opts)

-- split screen
keymap.set('n', '<leader>sv', ':vsplit<Return><C-w>w', opts)
keymap.set('n', '<leader>ss', ':split<Return><C-w>w', opts)

-- move windows
keymap.set('n', '<leader>S', '<C-w>w', opts)
keymap.set('', '<leader>H', '<C-w>h', opts)
keymap.set('', '<leader>K', '<C-w>k', opts)
keymap.set('', '<leader>J', '<C-w>j', opts)
keymap.set('', '<leader>L', '<C-w>l', opts)

-- resize windows
keymap.set('n', '<leader><left>', '<C-w><', opts)
keymap.set('n', '<leader><right>', '<C-w>>', opts)
keymap.set('n', '<leader><up>', '<C-w>+', opts)
keymap.set('n', '<leader><down>', '<C-w>-', opts)

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

-- github copilot
keymap.set('n', '<leader>cd', ':Copilot disable<CR>', opts)
keymap.set('n', '<leader>ce', ':Copilot enable<CR>', opts)
keymap.set('n', '<leader>cp', ':Copilot panel<CR>', opts)

-- Gitsigns null-ls code actions
keymap.set('n', '<leader>gs', ':lua vim.lsp.buf.code_action()<CR>', opts)

-- toggle wrap
keymap.set('n', '<A-z>', ':set wrap!<CR>', opts)
keymap.set('i', '<A-z>', '<esc> :set wrap!<CR>', opts)
