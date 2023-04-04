local nmap = require('dtsf.utils').nmap
local vmap = require('dtsf.utils').vmap
local imap = require('dtsf.utils').imap

local opts = { noremap = true, silent = true }

nmap { 'x', '"_x', opts }

-- common actions
imap { '<C-c>', '<Esc>', opts }

-- keep things centered when searching
nmap { 'n', 'nzzzv', opts }
nmap { 'N', 'Nzzzv', opts }

-- split screen
nmap { '<leader>[', ':vsplit<CR>', opts }
nmap { '<leader>]', ':split<CR>', opts }
nmap { '<leader>q', ':q<CR>', opts }

-- resize windows
nmap { '<leader><left>', '<C-w><', opts }
nmap { '<leader><right>', '<C-w>>', opts }
nmap { '<leader><up>', '<C-w>+', opts }
nmap { '<leader><down>', '<C-w>-', opts }

-- source config
nmap { '<leader>.', ':luafile %<CR>', opts }

-- copy to clipboard / delete
nmap { '<space>y', '"+y', opts }
vmap { '<space>y', '"+y', opts }
nmap { '<space>d', '_d', opts }
vmap { '<space>d', '_d', opts }
nmap { '<leader>p', [["_diwP]], opts } -- keep pasting over the same thing
nmap { '<leader>Y', 'gg"+yG', opts } -- copy all

-- move lines
vmap { 'J', ':m \'>+1<CR>gv=gv' }
vmap { 'K', ':m \'<-2<CR>gv=gv' }
nmap { '<leader>j', ':m .+1<CR>==', opts }
nmap { '<leader>k', ':m .-2<CR>==', opts }

-- toggle wrap
nmap { '<A-z>', ':set wrap!<CR>', opts }
imap { '<A-z>', '<esc> :set wrap!<CR>', opts }

-- indent lines in visual mode
vmap { '<', '<gv', opts }
vmap { '>', '>gv', opts }

-- change increment / decrement bindings
nmap { '<leader>a', '<C-a>', opts }
vmap { '<leader>a', '<C-a>', opts }
vmap { '<leader>fa', 'g<C-a>', opts }
nmap { '<leader>x', '<C-x>', opts }
vmap { '<leader>x', '<C-x>', opts }
vmap { '<leader>fx', 'g<C-x>', opts }

-- explorer / split explorer
nmap { '<leader>e', ':Explore<CR>', opts }
nmap { '<leader>ve', ':Vexplore<CR>', opts }
nmap { '<leader>se', ':Sexplore<CR>', opts }

-- cycle tabs
nmap { '<C-w>j', ':tabnext<CR>', opts }
nmap { '<C-w>k', ':tabprevious<CR>', opts }

-- rename all occurencies
nmap { '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts }
