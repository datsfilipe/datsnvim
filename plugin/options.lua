-- personal preferences
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes'
vim.opt.shada = { "'10", '<0', 's10', 'h' }
vim.opt.guicursor = 'a:blinkon5'
vim.opt.belloff = 'all'

vim.opt.inccommand = 'split'
vim.opt.updatetime = 50

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false -- no wrap lines
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.splitbelow = true -- put new windows below current
vim.opt.splitright = true -- put new windows right of current
vim.opt.smoothscroll = true

vim.g.markdown_recommended_style = 0

-- backup
vim.opt.swapfile = false
vim.opt.isfname:append '@-@'
vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand '~/.local/share/nvim/backup'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.undofile = true

-- folding
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.foldtext = ''
vim.opt.fillchars = 'fold: '

-- line numbers for netrw
vim.g.netrw_bufsettings = 'noma nomod nu nowrap ro nobl'

-- undercurl
vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]

-- format options
vim.opt.formatoptions:append { 'r' }
