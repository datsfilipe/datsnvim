local M = {}

local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', { silent = true }, opts or {}))
end

function M.setup()
  local options = { noremap = true, silent = true }

  map('i', '<C-c>', '<Esc>', vim.tbl_extend('force', options, { desc = 'curse' }))

  map('n', '<leader><leader>', '', vim.tbl_extend('force', options, { desc = 'no walking on space' }))

  map('n', '<C-d>', '<C-d>zz', { desc = 'scroll downwards' })
  map('n', '<C-u>', '<C-u>zz', { desc = 'scroll upwards' })
  map('n', 'n', 'nzzzv', { desc = 'next result' })
  map('n', 'N', 'Nzzzv', { desc = 'previous result' })

  map('v', '<', '<gv', vim.tbl_extend('force', options, { desc = 'indent left' }))
  map('v', '>', '>gv', vim.tbl_extend('force', options, { desc = 'indent right' }))
  map('n', '<A-z>', ':set wrap!<Return>', vim.tbl_extend('force', options, { desc = 'toggle wrap' }))

  map('v', 'J', ":m '>+1<Return>gv=gv", vim.tbl_extend('force', options, { desc = 'move lines down' }))
  map('v', 'K', ":m '<-2<Return>gv=gv", vim.tbl_extend('force', options, { desc = 'move lines up' }))
  map('n', '<leader>j', ':m .+1<Return>==', vim.tbl_extend('force', options, { desc = 'move line down' }))
  map('n', '<leader>k', ':m .-2<Return>==', vim.tbl_extend('force', options, { desc = 'move line down' }))

  map('n', ';]', ':split<Return>', options)
  map('n', ';[', ':vsplit<Return>', options)
  map('n', '<leader>-', '<C-w>_<C-w><Bar>', options)
  map('n', '<leader>=', '<C-w>=', options)

  map('n', '<leader>t', ':tabnew<Return>', options)
  map('n', '>', ':tabnext<Return>', options)
  map('n', '<', ':tabprev<Return>', options)

  map('n', '<leader>Y', 'ggVG"+y', options)
  map({ 'n', 'v' }, '<leader>y', [["+y]], options)
  map({ 'n', 'v' }, '<leader>d', [["_d]], options)
  map('x', '<leader>p', [["_dP]], options)

  map('n', ';o', 'o<Esc>^Da', options)
  map('n', ';O', 'O<Esc>^Da', options)
  map('n', ';p', ":let @+=expand('%:p')<Return>", options)
end

return M
