local utils = require 'user.utils'
local map = utils.map

local function highlight_qf(win)
  if not win or win == 0 then
    return
  end
  vim.wo[win].winhighlight = table.concat({
    'Normal:QuickFixLine',
    'NormalNC:QuickFixLine',
    'SignColumn:LineNr',
    'EndOfBuffer:LineNr',
  }, ',')
end

local function toggle_qf()
  local win_id = vim.fn.getqflist({ winid = 0 }).winid
  if win_id ~= nil and win_id ~= 0 then
    vim.cmd 'ccl'
    return
  end

  vim.cmd 'copen'
  local opened = vim.fn.getqflist({ winid = 0 }).winid
  highlight_qf(opened)
  vim.cmd 'wincmd p'
end

map('n', ';e', toggle_qf, { desc = 'toggle qf list' })

map(
  'n',
  '<C-p>',
  '<cmd>cprev<CR>zz<cmd>lua print("qflist: prev")<CR>',
  { desc = 'prev qf list item' }
)
map(
  'n',
  '<C-n>',
  '<cmd>cnext<CR>zz<cmd>lua print("qflist: next")<CR>',
  { desc = 'next qf list item' }
)
map(
  'n',
  ';E',
  '<cmd>call setqflist([], "r")<CR><cmd>ccl<CR><cmd>lua print("qflist: clear")<CR>',
  { desc = 'clear qf list' }
)

for i = 1, 9 do
  map('n', ';' .. i, function()
    vim.cmd('cc ' .. i)
    print('qflist: selected ' .. i)
  end, { desc = 'select qf list item in pos ' .. i })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function(args)
    highlight_qf(vim.api.nvim_get_current_win())
    vim.bo[args.buf].buflisted = false
  end,
})
