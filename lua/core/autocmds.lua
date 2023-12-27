require('custom.monkeytype').init(false)

-- turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'set nopaste',
})

-- disable the concealing in some file formats
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc', 'markdown' },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- set filetype of .astro files
vim.cmd [[au BufNewFile,BufRead *.astro setf astro]]

-- remove background of split and vpslit bars after colorscheme is applied
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.cmd [[hi VertSplit guibg=NONE]]
    vim.cmd [[hi SignColumn guibg=NONE]]
  end,
})

-- highlight yanked text for 200ms after yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { timeout = 200 }
  end,
})

-- highlight current line
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

set_cursorline('WinLeave', false, '*')
set_cursorline('WinEnter', true, '*')
set_cursorline('FileType', false, 'TelescopePrompt')
