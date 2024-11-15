local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>A', require('external.ast_grep').execute, opts) -- ast-grep
vim.keymap.set('i', '<C-c>', '<Esc>', opts) -- everybody has a cursed mapping
vim.keymap.set('n', 'x', '"_x')

-- avoid walking with space
vim.keymap.set('n', '<leader><leader>', function()
  vim.cmd 'so'
end, opts)

-- increment/decrement
vim.keymap.set({ 'n', 'v' }, '+', '<C-a>')
vim.keymap.set({ 'n', 'v' }, '-', '<C-x>')
vim.keymap.set('v', 'g+', 'g<C-a>', opts)
vim.keymap.set('v', 'g-', 'g<C-x>', opts)

-- move lines
vim.keymap.set('v', 'J', ":m '>+1<Return>gv=gv", opts)
vim.keymap.set('v', 'K', ":m '<-2<Return>gv=gv", opts)
vim.keymap.set('n', '<leader>j', ':m .+1<Return>==', opts)
vim.keymap.set('n', '<leader>k', ':m .-2<Return>==', opts)

vim.keymap.set('n', 'g;', '`[', opts) -- go back to last edited line

vim.keymap.set('n', '<leader>t', ':tabnew<Return>', opts)
vim.keymap.set('n', '>', ':tabnext<Return>', opts)
vim.keymap.set('n', '<', ':tabprev<Return>', opts)

-- split window
vim.keymap.set('n', '<leader>]', ':split<Return>', opts)
vim.keymap.set('n', '<leader>[', ':vsplit<Return>', opts)
vim.keymap.set('n', '<leader>-', '<C-w>_<C-w><Bar>', opts) -- maximize window
vim.keymap.set('n', '<leader>=', '<C-w>=', opts) -- equalize windows

-- indent lines
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('n', '<A-z>', ':set wrap!<Return>', opts) -- wrap lines

vim.keymap.set('n', '<leader>Y', 'ggVG"+y', opts) -- copy all
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], opts) -- copy to clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], opts) -- delete but don't yank
vim.keymap.set('x', '<leader>p', [["_dP]], opts) -- paste but don't yank the deleted text

-- replace occurrences
vim.keymap.set(
  'n',
  '<leader>r',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  opts
)

-- make file executable
vim.keymap.set('n', '<leader>x', ':!chmod +x %<Return>', opts)

-- datsvault (https://gist.github.com/datsfilipe/15a407d5bfbd21778787ccd02a8a2020)
vim.keymap.set(
  'n',
  '<leader>l',
  ':silent !tmux neww datsvault -l<Return>',
  opts
)

-- toggle inlay hints
vim.keymap.set('n', '<leader>hh', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 })
end, opts)

-- load specific keymaps
require 'keymaps.qflist'
require 'keymaps.sessionizer'
require 'keymaps.completion'
