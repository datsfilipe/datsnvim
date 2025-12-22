vim.opt.guicursor = 'n-v-c-i-ci-ve-sm:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor'

vim.wo.relativenumber = true
vim.wo.number = true

vim.o.complete = 'o,.,w,b,u'
vim.o.completeopt = 'menu,menuone,popup,noinsert'

vim.o.mouse = ''
vim.opt.cursorline = true
vim.opt.sidescrolloff = 8
vim.opt.smoothscroll = true

vim.o.sw = 2
vim.o.ts = 2
vim.o.et = true
vim.o.wrap = false
vim.o.confirm = true
vim.opt.inccommand = 'split'

vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.formatoptions:remove 'o'

vim.wo.signcolumn = 'yes:1'
vim.opt.winborder = 'none'
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.showmatch = false
vim.opt.pumheight = 15

vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.expand '~/.local/share/nvim/undodir'
vim.o.autoread = true

vim.opt.iskeyword:append '-'
vim.opt.diffopt:append 'vertical,context:99'
vim.opt.wildignore:append { '.DS_Store' }
vim.opt.shortmess:append {
  w = true,
  s = true,
}

vim.o.splitbelow = true
vim.o.splitright = true
