-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.pumblend = 0 -- important for transparency
opt.cmdheight = 1
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.laststatus = 3
opt.linebreak = true
opt.mouse = "a"
opt.path:append { "**" }
opt.relativenumber = true
opt.scrolloff = 10
opt.shortmess:append "c"
opt.showcmd = true
opt.showmatch = true
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 600
opt.title = true
opt.updatetime = 200
opt.wrap = false
opt.shell = "zsh"
opt.shada = { "!,'1000,<50,s10,h" }
opt.modelines = 1
opt.belloff = "all"

-- tabs
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- visual options
opt.guicursor = "a:blinkon5"
opt.number = true
opt.ruler = false
opt.fillchars = {
  vert = "│",
  eob = " ",
  diff = " ",
  msgsep = " ",
}

-- search options
opt.smarttab = true

-- completion options
opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
opt.complete = { ".,w,b,u,t,i,kspell" }
opt.dictionary = "/usr/share/dict/words"

-- split options
opt.equalalways = false

-- indent options
opt.autoindent = true
opt.breakindent = true
opt.formatoptions:append { "r" }

-- file options
opt.swapfile = false
opt.isfname:append "@-@"
opt.wildignore:append { "*/node_modules/*" }
opt.wildignore:append { "Cargo.lock" }
opt.backup = true
opt.backupdir = vim.fn.expand "~/.local/share/nvim/backup"
opt.backupskip = { "/tmp/*", "/private/tmp/*" }
opt.undofile = true

-- diff options
opt.diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }

-- encoding
opt.encoding = "utf-8"
vim.scriptencoding = "utf-8"
opt.fileencoding = "utf-8"