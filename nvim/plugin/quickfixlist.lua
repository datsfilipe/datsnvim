local function toggle_qf()
  local win_id = vim.fn.getqflist({ winid = 0 }).winid
  if win_id ~= nil and win_id ~= 0 then
    vim.cmd 'ccl'
  else
    vim.cmd 'copen'
    vim.cmd 'wincmd p'
  end
end

vim.keymap.set('n', ';e', toggle_qf, { desc = 'quickfix list: toggle' })
vim.keymap.set(
  'n',
  '<C-p>',
  '<cmd>cprev<CR>zz<cmd>lua print("qflist: prev")<CR>',
  { desc = 'quickfix list: prev' }
)
vim.keymap.set(
  'n',
  '<C-n>',
  '<cmd>cnext<CR>zz<cmd>lua print("qflist: next")<CR>',
  { desc = 'quickfix list: next' }
)
vim.keymap.set(
  'n',
  ';E',
  '<cmd>call setqflist([], "r")<CR><cmd>ccl<CR><cmd>lua print("qflist: clear")<CR>',
  { desc = 'quickfix list: clear' }
)

for i = 1, 9 do
  vim.keymap.set('n', ';' .. i, function()
    vim.cmd('cc ' .. i)
    print('qflist: selected ' .. i)
  end, { desc = 'quickfix list: select ' .. i })
end
