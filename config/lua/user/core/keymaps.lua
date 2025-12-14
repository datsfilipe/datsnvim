local utils = require 'user.utils'
local map = utils.map
local opts = utils.map_options

-- curse
map('i', '<C-c>', '<Esc>', vim.tbl_extend('force', opts, { desc = 'curse' }))
map(
  'n',
  '<leader><leader>',
  '',
  vim.tbl_extend('force', opts, { desc = 'no walking on space' })
)

-- keep center
map('n', '<C-d>', '<C-d>zz', { desc = 'scroll downwards' })
map('n', '<C-u>', '<C-u>zz', { desc = 'scroll upwards' })
map('n', 'n', 'nzzzv', { desc = 'next' })
map('n', 'N', 'Nzzzv', { desc = 'prev' })

-- indent
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)
map('n', '<A-z>', ':set wrap!<CR>', opts)

-- move lines
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)
map('n', ';j', ':m .+1<CR>==', opts)
map('n', ';k', ':m .-2<CR>==', opts)

-- clipboard
map('n', '<leader>Y', 'ggVG"+y', opts)
map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map({ 'n', 'v' }, '<leader>d', '"_d', opts)
map('x', '<leader>p', '"_dP', opts)

-- UI
map('n', ';s', ':split<CR>', opts)
map('n', ';v', ':vsplit<CR>', opts)
map('n', '<C-.>', ':bnext<CR>', opts)
map('n', '<C-,>', ':bprev<CR>', opts)
map('n', ';t', ':tabnew<CR>', opts)
map('n', ';c', ':tabclose<CR>', opts)
map('n', '>', ':tabn<CR>', opts)
map('n', '<', ':tabp<CR>', opts)
