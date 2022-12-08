local opt = vim.opt

-- general
opt.backspace = { 'start', 'eol', 'indent' }
opt.inccommand = 'split'
opt.path:append { '**' } -- finding files - search down into subfolders
opt.diffopt = { 'internal', 'filler', 'closeoff', 'hiddenoff', 'algorithm:minimal' }
opt.joinspaces = false
opt.shell = 'fish'
opt.cmdheight = 1
opt.timeoutlen = 600
opt.updatetime = 1000 -- make updates happen faster
opt.showcmd = true
opt.showmode = false
opt.scrolloff = 10

-- split
opt.equalalways = false
opt.splitbelow = true
opt.splitright = true

-- file
opt.backup = false
vim.scriptencoding = 'utf-8'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.swapfile = false
opt.undofile = true
opt.wildignore:append { '*/node_modules/*' }
opt.wildignore:append { 'Cargo.lock' }

-- search
opt.incsearch = true
opt.hlsearch = true
opt.showmatch = true
opt.ignorecase = true -- ignore case when searching...
opt.smartcase = true

-- tabs
opt.foldmethod = 'marker'
opt.foldlevel = 0
opt.modelines = 1
opt.belloff = 'all'
opt.shada = { '!', '\'1000', '<50', 's10', 'h' }
opt.hidden = true

-- indent
opt.expandtab = true
opt.wrap = false -- no wrap lines
opt.showbreak = string.rep(' ', 3) -- Make it so that long lines wrap smartly
opt.smarttab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.linebreak = true

-- ui options
opt.number = true
opt.relativenumber = true
opt.title = true

opt.ruler = false
opt.guicursor = 'a:blinkon5' -- set same cursor to all modes (5 is the blink time)
opt.laststatus = 3
opt.fillchars = {
  vert = '│',
  eob = ' ',
  diff = ' ',
  msgsep = ' ',
}

opt.wildmode = 'longest:full'
opt.wildoptions = 'pum'

-- undercurl
vim.cmd [[let &t_Cs = '\e[4:3m']]
vim.cmd [[let &t_Ce = '\e[4:0m']]

-- disable intro
opt.shortmess:append 'sI'

-- format options
opt.formatoptions = opt.formatoptions
  - 'o' -- O and o, don't continue comments
  - 'a' -- auto formatting is BAD
  - 't' -- don't auto format code
  - '2' -- not in gradeschool anymore
  + 'c' -- comments respect textwidth
  + 'q' -- allow formatting comments w/ gq
  + 'r' -- but do continue when pressing enter
  + 'n' -- indent past the formatlistpat, not underneath it
  + 'j' -- auto-remove comments if possible
