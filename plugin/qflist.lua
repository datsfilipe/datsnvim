local function toggle_qf()
  local win_id = vim.fn.getqflist({ winid = 0 }).winid
  if win_id ~= nil and win_id ~= 0 then
    vim.cmd 'ccl'
  else
    vim.cmd 'copen'
    vim.cmd 'wincmd p'
  end
end

vim.keymap.set('n', ';e', toggle_qf)
vim.keymap.set('n', '<C-p>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>zz')

-- clean quickfix list and close
vim.keymap.set('n', ';E', '<cmd>call setqflist([], "r")<CR><cmd>ccl<CR>')
