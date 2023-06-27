local opt = vim.opt

-- global options
opt.cmdheight = 1
opt.encoding = 'utf-8'
opt.expandtab = true
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.laststatus = 3
opt.linebreak = true
opt.mouse = 'a'
opt.path:append { '**' }
opt.relativenumber = true
opt.scrolloff = 10
opt.shiftwidth = 2
opt.shortmess:append 'c'
opt.showcmd = true
opt.showmatch = true
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 2
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 600
opt.title = true
opt.updatetime = 1000
opt.wrap = false

-- visual options
opt.guicursor = 'a:blinkon5'
opt.number = true
opt.ruler = false
opt.fillchars = {
  vert = '│',
  eob = ' ',
  diff = ' ',
  msgsep = ' ',
}

-- search options
opt.smarttab = true

-- completion options
opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }
opt.complete = { '.,w,b,u,t,i,kspell' }
opt.dictionary = '/usr/share/dict/words'

-- split options
opt.equalalways = false

-- indent options
opt.autoindent = true
opt.breakindent = true
opt.formatoptions:append { 'r' }

-- file options
vim.scriptencoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.swapfile = false
opt.isfname:append '@-@'
opt.wildignore:append { '*/node_modules/*' }
opt.wildignore:append { 'Cargo.lock' }
opt.backup = true
opt.backupdir = vim.fn.expand '~/.local/share/nvim/backup'
opt.backupskip = { '/tmp/*', '/private/tmp/*' }
opt.undofile = true

-- diff options
opt.diffopt = { 'internal', 'filler', 'closeoff', 'hiddenoff', 'algorithm:minimal' }

-- shell options
opt.shell = 'zsh'

-- shada options
opt.shada = { '!,\'1000,<50,s10,h' }

-- modeline options
opt.modelines = 1

-- belloff options
opt.belloff = 'all'