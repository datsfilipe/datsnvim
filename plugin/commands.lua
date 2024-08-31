local function parse_git_blame_output(output)
  local parsed_lines = {}
  for line in output:gmatch '[^\r\n]+' do
    local commit, author, date =
      line:match '^(%w+)%s+%(([^%)]-)%s+(%d%d%d%d%-%d%d%-%d%d)'
    if author == 'Not Committed Yet' then
      author = 'none'
    end
    if commit and author and date then
      table.insert(parsed_lines, commit .. ' ' .. date .. ' ' .. author)
    end
  end
  return parsed_lines
end

local function git_blame()
  local file = vim.fn.expand '%:p'
  local cmd = string.format('git blame --date=short %s', file)
  local cmd_output = vim.fn.systemlist(cmd)

  if #cmd_output == 0 then
    print 'Git blame returned no output.'
    return
  end

  local parsed_lines = parse_git_blame_output(table.concat(cmd_output, '\n'))

  local buf = vim.api.nvim_create_buf(false, true)
  if #parsed_lines > 0 then
    for _, line in ipairs(parsed_lines) do
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
    end
  end

  vim.api.nvim_command 'vsplit'

  local win = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_buf_set_name(buf, 'Git Blame')
  local buf_name = 'Git Blame'
  vim.api.nvim_buf_set_name(buf, buf_name)
  vim.api.nvim_win_set_width(win, 40)
  vim.api.nvim_create_autocmd('BufDelete', {
    buffer = buf,
    once = true,
    callback = function()
      vim.api.nvim_buf_delete(buf, { force = true })
    end,
  })
end

vim.api.nvim_create_user_command('CustomGitBlame', git_blame, {})
