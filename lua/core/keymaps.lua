require('custom.discipline').cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set('n', 'ze', require('custom.excalidraw').open, opts)

-- ast-grep
keymap.set('n', '<leader>A', require('custom.ast-grep').execute, opts)

keymap.set('i', '<C-c>', '<Esc>', opts)
keymap.set('n', 'x', '"_x')

-- avoid walking with space
keymap.set('n', '<leader><leader>', function()
  vim.cmd 'so'
end, opts)

-- increment/decrement
keymap.set({ 'n', 'v' }, '+', '<C-a>')
keymap.set({ 'n', 'v' }, '-', '<C-x>')
keymap.set('v', 'g+', 'g<C-a>', opts)
keymap.set('v', 'g-', 'g<C-x>', opts)

-- move lines
keymap.set('v', 'J', ":m '>+1<Return>gv=gv", opts)
keymap.set('v', 'K', ":m '<-2<Return>gv=gv", opts)
keymap.set('n', '<leader>j', ':m .+1<Return>==', opts)
keymap.set('n', '<leader>k', ':m .-2<Return>==', opts)

-- go back to last edited line
keymap.set('n', 'g;', '`[', opts)

-- disable continuations
keymap.set('n', '<Leader>o', 'o<Esc>^Da', opts)
keymap.set('n', '<Leader>O', 'O<Esc>^Da', opts)

-- new tab
keymap.set('n', '<leader>t', ':tabnew<Return>', opts)
keymap.set('n', '>', ':tabnext<Return>', opts)
keymap.set('n', '<', ':tabprev<Return>', opts)
-- split window
keymap.set('n', '<leader>]', ':split<Return>', opts)
keymap.set('n', '<leader>[', ':vsplit<Return>', opts)
-- maximize window
keymap.set('n', '<leader>-', '<C-w>_<C-w><Bar>', opts)
-- equalize windows
keymap.set('n', '<leader>=', '<C-w>=', opts)

-- wrap lines
keymap.set('n', '<A-z>', ':set wrap!<Return>', opts)
-- indent lines
keymap.set('v', '<', '<gv', opts)
keymap.set('v', '>', '>gv', opts)

-- netrw
keymap.set('n', '<leader>e', ':Explore<Return><Return>', opts)
keymap.set('n', '<leader>s', ':Sex<Return><Return>', opts)

-- copy all
keymap.set('n', '<leader>Y', 'ggVG"+y', opts)
-- copy to clipboard
keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], opts)

-- delete but don't yank
keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], opts)
-- paste but don't yank the deleted text
keymap.set('x', '<leader>p', [["_dP]], opts)

-- replace occurences
keymap.set('n', '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)

-- make file executable
keymap.set('n', '<leader>x', ':!chmod +x %<Return>', opts)

-- tmux-sessionizer (https://github.com/datsfilipe/unix-scripts/blob/main/tmux-sessionizer)
keymap.set('n', '<C-f>', ':silent !tmux neww tmux-sessionizer<Return>', opts)
-- datsvault (https://gist.github.com/datsfilipe/15a407d5bfbd21778787ccd02a8a2020)
keymap.set('n', '<leader>l', ':silent !tmux neww datsvault -l<Return>', opts)
