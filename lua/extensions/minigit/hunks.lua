local M = {}

function M.list_hunks()
  local file = vim.fn.expand '%:p'
  local root = vim.fn.systemlist({ 'git', 'rev-parse', '--show-toplevel' })[1]
  if vim.v.shell_error ~= 0 then
    print 'not a git repo'
    return
  end
  vim.cmd('cd ' .. vim.fn.fnameescape(root))

  local diff =
    vim.fn.systemlist { 'git', 'diff', '--unified=0', '--no-color', '--', file }
  if vim.v.shell_error ~= 0 then
    print 'git diff failed'
    return
  end
  if vim.tbl_isempty(diff) then
    print 'no hunks to show'
    return
  end

  local qf = {}
  for _, line in ipairs(diff) do
    local _, _, new_start = line:find '^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@'
    if new_start then
      table.insert(qf, {
        filename = file,
        lnum = tonumber(new_start),
        col = 1,
        text = line,
      })
    end
  end

  if #qf == 0 then
    print 'no hunk headers found'
    return
  end

  vim.fn.setqflist(qf, 'r')
  vim.cmd 'copen'
end

return M
