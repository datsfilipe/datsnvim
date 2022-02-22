-- set leader key
vim.g.mapleader = ' '

local options = {
  ru = false,                               -- disable ruler
  list = true,
  clipboard = "unnamedplus",                -- universal clipboard support
  completeopt = { "menuone", "noselect" },  -- mostly for cmp
  conceallevel = 0,                         -- make `` visible in markdown
  fileencoding = "UTF-8",                   -- the encoding written to a file
  hidden = true,                            -- for maintain multiple buffers open
  hlsearch = true,                          -- highlight all matches previous search pattern
  ignorecase = true,                        -- ignore case in search patterns
  mouse = "a",                              -- allow mouse
  lazyredraw = true,                        -- faster macros i think
  showtabline = 2,                          -- always show tabs
  smartcase = true,                         -- smart case
  smartindent = true,                       -- make identation smarter
  splitbelow = true,                        -- split horizontally below the current window
  splitright = true,                        -- split vertically in right of the current window
  fillchars = "eob: ",                      -- remove ugly eob tilde fringe
  swapfile = false,                         -- no swap
  undofile = true,                          -- enable undo
  updatetime = 500,                         -- increase the update time
  writebackup = false,                      -- no backup
  expandtab = true,                         -- covert tabs to spaces
  shiftwidth = 0,                           -- number of spaces inserted for each identation
  tabstop = 2,                              -- insert two spaces for a tab  
  wrap = false,                             -- no initial wrap
  number = false,                           -- no number column  
  signcolumn = "auto:1-9",                  -- as many signs in the signcolumn as we want!
  scrolloff = 3,                            -- add some padding while scrolling
  sidescrolloff = 3,
  statusline = "%F%m%r%h%w: %2l",           -- my fav one, minimalist status line
  guifont = "JetBrainsMono Nerd Font:h15",  -- font for graphical applications
  termguicolors = true,
}

-- use nvim-notify as the default notification system
local status_ok, notify = pcall(require, 'notify')
if status_ok then
  vim.notify = notify
end

vim.opt.shortmess:append "c"

for a, b in pairs(options) do
  vim.opt[a] = b
end

vim.cmd "set whichwrap+=<,>,[,],h,l"

-- disable unnecessary plugins
local not_going_built_ins = {
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in pairs(not_going_built_ins) do
   vim.g["loaded_" .. plugin] = 1
end
