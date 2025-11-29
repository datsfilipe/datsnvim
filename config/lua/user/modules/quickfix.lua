local M = {}

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

function M.setup()
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

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function(args)
      highlight_qf(vim.api.nvim_get_current_win())
      vim.bo[args.buf].buflisted = false
    end,
  })
end

return M
