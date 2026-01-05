vim.keymap.set('i', '<C-c>', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space><Space>', '', { noremap = true, silent = true })

vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'next' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'prev' })

vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })
vim.keymap.set('n', '<A-z>', ':set wrap!<CR>', { noremap = true, silent = true })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>j', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>k', ':m .-2<CR>==', { noremap = true, silent = true })

vim.keymap.set('n', '<Space>Y', 'ggVG"+y', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<Space>y', '"+y', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<Space>d', '"_d', { noremap = true, silent = true })
vim.keymap.set('x', '<Space>p', '"_dP', { noremap = true, silent = true })

vim.keymap.set('n', '<C-.>', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-,>', ':bprev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>t', ':tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '>', ':tabn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<', ':tabp<CR>', { noremap = true, silent = true })

vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes('<C-y>', true, true, true)
  else
    return vim.api.nvim_replace_termcodes('<CR>', true, true, true)
  end
end, { expr = true, noremap = true, silent = true })

vim.keymap.set('n', 'gd', '<C-]>', { noremap = true, silent = true })
