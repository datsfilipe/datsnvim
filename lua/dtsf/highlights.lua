local opt = vim.opt

opt.signcolumn = 'yes'
opt.termguicolors = true
opt.termguicolors = true
opt.pumblend = 0 -- disable popup menu transparency
opt.background = 'dark'

-- cursor line
opt.cursorline = true -- Highlight the current line
local group = vim.api.nvim_create_augroup('CursorLineControl', { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline('WinLeave', false)
set_cursorline('WinEnter', true)
set_cursorline('FileType', false, 'TelescopePrompt')

-- remove highlight for split and vsplit bars after colorscheme is applied
vim.cmd [[autocmd ColorScheme * highlight VertSplit guibg=NONE]}]]

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd [[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=100})
  augroup END
]]
