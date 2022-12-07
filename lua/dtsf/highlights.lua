local opt = vim.opt

opt.signcolumn = 'yes'
opt.termguicolors = true
opt.termguicolors = true
opt.pumblend = 5
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
