local function toggle_qf()
  local win_id = vim.fn.getqflist({ winid = 0 }).winid
  if win_id ~= nil and win_id ~= 0 then
    vim.cmd 'ccl'
    return
  end

  vim.cmd 'copen'
  vim.cmd 'wincmd p'
end

vim.keymap.set('n', '<leader>q', toggle_qf, { desc = 'toggle qf list' })
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>')
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<leader>Q', '<cmd>call setqflist([], "r")<CR><cmd>ccl<CR>')

for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, function()
    vim.cmd('cc ' .. i)
  end)
end
