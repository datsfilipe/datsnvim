require('utils.monkeytype_surprise').init()

-- turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'set nopaste',
})

-- disable concealing in some file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc', 'markdown' },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- set filetype of .astro files
vim.cmd [[au BufNewFile,BufRead *.astro setf astro]]

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
