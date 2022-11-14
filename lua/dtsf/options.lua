vim.cmd('autocmd!')

local opt = vim.opt
local g = vim.g

-- general options
vim.scriptencoding = 'utf-8'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.backspace = { 'start', 'eol', 'indent' }
opt.inccommand = 'split'
opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
opt.path:append { '**' } -- finding files - search down into subfolders
opt.scrolloff = 8
opt.shell = 'fish'
opt.backup = false
opt.backupskip = { '/tmp/*', '/private/tmp/*' }
opt.showcmd = true
opt.cmdheight = 1
opt.hlsearch = true
opt.timeoutlen = 600
opt.undofile = true
opt.splitbelow = true
opt.splitright = true
opt.wildignore:append { '*/node_modules/*' }
opt.swapfile = false

-- ui options
opt.number = true
opt.relativenumber = true
opt.ruler = false
opt.title = true
opt.guicursor = 'a:blinkon5' -- set same cursor to all modes (5 is the blink time)
opt.laststatus = 3
opt.hidden = true
opt.fillchars = {
  vert = "│",
  eob = " ",
  diff = " ",
  msgsep = " "
}

-- indenting options
opt.expandtab = true
opt.shiftwidth = 2
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.wrap = false -- no wrap lines
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true

-- highlight options
opt.signcolumn = 'yes'
opt.termguicolors = true
opt.cursorline = true
opt.termguicolors = true
opt.winblend = 0
opt.wildoptions = 'pum'
opt.pumblend = 5
opt.background = 'dark'

-- undercurl
vim.cmd([[let &t_Cs = '\e[4:3m']])
vim.cmd([[let &t_Ce = '\e[4:0m']])

-- disable intro
opt.shortmess:append 'sI'

-- turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'set nopaste'
})

-- add asterisks in block comments
opt.formatoptions:append { 'r' }

-- disable some builtin vim plugins
local default_plugins = {
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'matchit',
  'tar',
  'tarPlugin',
  'rrhelper',
  'spellfile_plugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin'
}

for _, plugin in pairs(default_plugins) do
  g['loaded_' .. plugin] = 1
end

local default_providers = {
  'node',
  'perl',
  'python3',
  'ruby',
}

for _, provider in ipairs(default_providers) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- remove highlight for split and vsplit bars after colorscheme is applied
vim.cmd [[autocmd ColorScheme * highlight VertSplit guibg=NONE]]
