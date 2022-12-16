local nmap = require('dtsf.keymap').nmap
local vmap = require('dtsf.keymap').vmap
local imap = require('dtsf.keymap').imap

local opts = { noremap = true, silent = true }

nmap { 'x', '"_x', opts }

-- common actions
imap { '<C-c>', '<Esc>', opts }
nmap { '<C-s>', ':w<CR>', opts }
nmap { '<C-q>', ':q<CR>', opts }

-- keep things centered when searching
nmap { 'n', 'nzzzv', opts }
nmap { 'N', 'Nzzzv', opts }

-- split screen
nmap { '<leader>v', ':vsplit<CR>', opts }
nmap { '<leader>s', ':split<CR>', opts }
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
