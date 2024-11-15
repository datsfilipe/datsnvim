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
vim.keymap.set(
  'n',
  '<C-p>',
  '<cmd>cprev<CR>zz<cmd>lua print("qflist: prev")<CR>'
)
vim.keymap.set(
  'n',
  '<C-n>',
  '<cmd>cnext<CR>zz<cmd>lua print("qflist: next")<CR>'
)

for i = 1, 9 do
  vim.keymap.set('n', 'ge' .. i, function()
    vim.cmd('cc ' .. i)
    print('qflist: selected ' .. i)
  end)
end

-- clean quickfix list and close
vim.keymap.set('n', ';E', '<cmd>call setqflist([], "r")<CR><cmd>ccl<CR>')

-- search with vimgrep through all git tracked files
vim.keymap.set('n', ';s', function()
  local pattern = vim.fn.input 'search: '
  local cmd = [[vimgrep /]]
    .. pattern
    .. [[/j `git ls-files --full-name :/ \| sed "s;^;$(git rev-parse --show-toplevel)/;"` | copen | wincmd p]]
  return vim.cmd(cmd)
end)
