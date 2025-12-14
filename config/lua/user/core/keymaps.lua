local utils = require 'user.utils'

-- curse
utils.map(
  'i',
  '<C-c>',
  '<Esc>',
  vim.tbl_extend('force', utils.map_options, { desc = 'curse' })
)

utils.map(
  'n',
  '<leader><leader>',
  '',
  vim.tbl_extend('force', utils.map_options, { desc = 'no walking on space' })
)

-- keep center of screen
utils.map('n', '<C-d>', '<C-d>zz', { desc = 'scroll downwards' })
utils.map('n', '<C-u>', '<C-u>zz', { desc = 'scroll upwards' })
utils.map('n', 'n', 'nzzzv', { desc = 'next result' })
utils.map('n', 'N', 'Nzzzv', { desc = 'previous result' })

-- indent
utils.map(
  'v',
  '<',
  '<gv',
  vim.tbl_extend('force', utils.map_options, { desc = 'indent left' })
)
utils.map(
  'v',
  '>',
  '>gv',
  vim.tbl_extend('force', utils.map_options, { desc = 'indent right' })
)
utils.map(
  'n',
  '<A-z>',
  ':set wrap!<Return>',
  vim.tbl_extend('force', utils.map_options, { desc = 'toggle wrap' })
)

-- move lines
utils.map(
  'v',
  'J',
  ":m '>+1<Return>gv=gv",
  vim.tbl_extend('force', utils.map_options, { desc = 'move lines down' })
)
utils.map(
  'v',
  'K',
  ":m '<-2<Return>gv=gv",
  vim.tbl_extend('force', utils.map_options, { desc = 'move lines up' })
)
utils.map(
  'n',
  ';j',
  ':m .+1<Return>==',
  vim.tbl_extend('force', utils.map_options, { desc = 'move line down' })
)
utils.map(
  'n',
  ';k',
  ':m .-2<Return>==',
  vim.tbl_extend('force', utils.map_options, { desc = 'move line down' })
)

-- copy & paste
utils.map('n', '<leader>Y', 'ggVG"+y', utils.map_options)
utils.map({ 'n', 'v' }, '<leader>y', [["+y]], utils.map_options)
utils.map({ 'n', 'v' }, '<leader>d', [["_d]], utils.map_options)
utils.map('x', '<leader>p', [["_dP]], utils.map_options)

-- split
utils.map('n', ';s', ':split<Return>', utils.map_options)
utils.map('n', ';v', ':vsplit<Return>', utils.map_options)

-- buf
utils.map('n', '<C-.>', ':bnext<cr>', utils.map_options)
utils.map('n', '<C-,>', ':bprev<cr>', utils.map_options)

-- tab
utils.map('n', ';t', ':tabnew<CR>', utils.map_options)
utils.map('n', ';c', ':tabclose<CR>', utils.map_options)
utils.map('n', '>', ':tabn<CR>', utils.map_options)
utils.map('n', '<', ':tabp<CR>', utils.map_options)
