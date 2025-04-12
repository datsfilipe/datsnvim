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

  if next_diff > 0 and next_diff > current_line then
    vim.fn.cursor(next_diff, 1)
  else
    print 'No more diffs.'
  end
end

function PrevDiff()
  local current_line = vim.fn.line '.'
  local prev_diff = vim.fn.search('^<<<<<<<', 'bn')

  if prev_diff > 0 and prev_diff < current_line then
    vim.fn.cursor(prev_diff, 1)
  else
    print 'No more diffs.'
  end
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()

    local is_diff = vim.opt.diff:get()

    local has_conflicts = false
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for _, line in ipairs(lines) do
      if line:match '^<<<<<<<' then
        has_conflicts = true
        break
      end
    end

    if is_diff or has_conflicts then
      vim.api.nvim_buf_set_keymap(
        buf,
        'n',
        'co',
        [[:lua ResolveConflict(1)<CR>]],
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        buf,
        'n',
        'cb',
        [[:lua ResolveConflict(2)<CR>]],
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        buf,
        'n',
        'ct',
        [[:lua ResolveConflict(3)<CR>]],
        { noremap = true, silent = true }
      )

      vim.api.nvim_buf_set_keymap(
        buf,
        'n',
        'cn',
        [[:lua NextDiff()<CR>]],
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        buf,
        'n',
        'cp',
        [[:lua PrevDiff()<CR>]],
        { noremap = true, silent = true }
      )

      print 'Conflict resolution mappings enabled'
    end
  end,
})
