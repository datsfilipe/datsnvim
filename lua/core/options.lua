vim.g.mapleader = ' '

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.guicursor = 'a:blinkon5'
vim.opt.belloff = 'all'

vim.opt.updatetime = 100

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = 'zsh'
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false         -- no wrap lines
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.splitbelow = true    -- put new windows below current
vim.opt.splitright = true    -- put new windows right of current
vim.opt.splitkeep = 'cursor'
vim.opt.mouse = ''
vim.opt.conceallevel = 3

-- backup
vim.opt.swapfile = false
vim.opt.isfname:append '@-@'
vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand '~/.local/share/nvim/backup'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.undofile = true

-- folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- line numbers for netrw
vim.g.netrw_bufsettings = 'noma nomod nu nowrap ro nobl'

-- undercurl
vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]

-- add asterisks in block comments
vim.opt.formatoptions:append { 'r' }

if vim.fn.has 'nvim-0.8' == 1 then
  vim.opt.cmdheight = 0
end
