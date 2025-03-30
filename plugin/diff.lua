vim.api.nvim_set_keymap(
  'n',
  'co',
  [[:lua ResolveConflict(1)<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  'cb',
  [[:lua ResolveConflict(2)<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  'ct',
  [[:lua ResolveConflict(3)<CR>]],
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n',
  'cn',
  [[:lua NextDiff()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  'cp',
  [[:lua PrevDiff()<CR>]],
  { noremap = true, silent = true }
)

function ResolveConflict(source)
  local start = vim.fn.search('^<<<<<<<', 'bn')
  local finish = vim.fn.search('^>>>>>>>', 'n')

  if start > 0 and finish > 0 then
    vim.cmd(start .. ',' .. finish .. 'diffget ' .. source)
  else
    print 'No conflict found'
  end
end

function NextDiff()
  local current_line = vim.fn.line '.'
  local next_diff = vim.fn.search('^<<<<<<<', 'n')

  -- Search for next diff starting from current position
  if next_diff > 0 and next_diff > current_line then
    vim.fn.cursor(next_diff, 1)
  else
    print 'No more diffs.'
  end
end

function PrevDiff()
  local current_line = vim.fn.line '.'
  local prev_diff = vim.fn.search('^<<<<<<<', 'bn')

  -- Search for previous diff starting from current position
  if prev_diff > 0 and prev_diff < current_line then
    vim.fn.cursor(prev_diff, 1)
  else
    print 'No more diffs.'
  end
end
