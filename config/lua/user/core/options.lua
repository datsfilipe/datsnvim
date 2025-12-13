vim.opt.guicursor = 'n-v-c-i-ci-ve-sm:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor'

vim.wo.relativenumber = true
vim.wo.number = true

vim.o.mouse = ''
vim.opt.cursorline = true
vim.opt.sidescrolloff = 8

vim.o.sw = 2
vim.o.ts = 2
vim.o.et = true
vim.o.wrap = false

vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'
vim.opt.winborder = 'none'
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.showmode = false
vim.opt.showmatch = false
vim.opt.pumheight = 15
vim.opt.pumblend = 10

vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.expand '~/.local/share/nvim/undodir'
vim.o.autowrite = false
vim.o.autoread = true

vim.opt.list = true
vim.opt.iskeyword:append('-')
vim.opt.listchars = { lead = '.', trail = '.', tab = '  -' }
vim.opt.fillchars = {
  eob = ' ',
  fold = '-',
  foldclose = '<',
  foldopen = '>',
  foldsep = ' ',
  msgsep = '─',
}

vim.opt.diffopt:append 'vertical,context:99'
vim.opt.wildignore:append { '.DS_Store' }
vim.opt.shortmess:append {
  w = true,
  s = true,
}

vim.o.splitbelow = true
vim.o.splitright = true

vim.g.clipboard = {
  name = 'smart-clipboard',
  copy = {
    ['+'] = 'shared-clipboard copy',
  },
  paste = {
    ['+'] = 'shared-clipboard paste',
  },
}
