local utils = require 'user.utils'

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

utils.map('n', '<C-d>', '<C-d>zz', { desc = 'scroll downwards' })
utils.map('n', '<C-u>', '<C-u>zz', { desc = 'scroll upwards' })
utils.map('n', 'n', 'nzzzv', { desc = 'next result' })
utils.map('n', 'N', 'Nzzzv', { desc = 'previous result' })

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
  '<leader>j',
  ':m .+1<Return>==',
  vim.tbl_extend('force', utils.map_options, { desc = 'move line down' })
)
utils.map(
  'n',
  '<leader>k',
  ':m .-2<Return>==',
  vim.tbl_extend('force', utils.map_options, { desc = 'move line down' })
)

utils.map('n', ';]', ':split<Return>', utils.map_options)
utils.map('n', ';[', ':vsplit<Return>', utils.map_options)
utils.map('n', '<leader>-', '<C-w>_<C-w><Bar>', utils.map_options)
utils.map('n', '<leader>=', '<C-w>=', utils.map_options)

utils.map('n', '<leader>t', ':tabnew<Return>', utils.map_options)
utils.map('n', '>', ':tabnext<Return>', utils.map_options)
utils.map('n', '<', ':tabprev<Return>', utils.map_options)

utils.map('n', '<leader>Y', 'ggVG"+y', utils.map_options)
utils.map({ 'n', 'v' }, '<leader>y', [["+y]], utils.map_options)
utils.map({ 'n', 'v' }, '<leader>d', [["_d]], utils.map_options)
utils.map('x', '<leader>p', [["_dP]], utils.map_options)

utils.map('n', ';o', 'o<Esc>^Da', utils.map_options)
utils.map('n', ';O', 'O<Esc>^Da', utils.map_options)
utils.map('n', ';p', ":let @+=expand('%:p')<Return>", utils.map_options)
