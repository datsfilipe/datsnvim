local function parse_git_blame_output(output)
  local hash, author, date =
    string.match(output, '(%x+)%s+%((.-)%s+(%d%d%d%d%-%d%d%-%d%d)%s*%)')

  if not hash then
    hash = string.match(output, '^(%x+)')
  end

  if not hash then
    return nil
  end

  if not author then
    author = string.match(output, '%((.-)%d%d%d%d%-%d%d%-%d%d') or 'Unknown'
    author = author:gsub('%s+$', '')
  end

  if not date then
    date = string.match(output, '(%d%d%d%d%-%d%d%-%d%d)')
    if not date then
      date = os.date '%Y-%m-%d'
    end
  end

  if hash:match '^0+$' then
    hash = '00000000'
    author = 'Not Committed Yet'
  end

  return {
    hash = hash,
    author = author:gsub('^%s*(.-)%s*$', '%1'),
    date = date,
  }
end

local function create_blame_popup()
  local file = vim.fn.expand '%:p'
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local cmd =
    string.format('git blame -L %d,%d --date=short %s', line, line, file)

  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to get git blame info', vim.log.levels.ERROR)
    return
  end

  output = output:match '[^\n]+' or output

  local blame_info = parse_git_blame_output(output)
  if not blame_info then
    vim.notify('Could not parse git blame output', vim.log.levels.ERROR)
    return
  end

  if blame_info.hash == '00000000' then
    vim.notify('not committed yet', vim.log.levels.INFO)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)

  local lines = {
    string.format('~ %s', blame_info.hash),
    string.format('@ %s', blame_info.author),
    string.format('- %s', blame_info.date),
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = math.max(#lines[1], #lines[2], #lines[3])
  local height = #lines

  local editor_width = vim.api.nvim_win_get_width(0)
  local editor_height = vim.api.nvim_win_get_height(0)

  local win_row = vim.fn.winline()
  local win_col = vim.fn.wincol()

  if win_row + height >= editor_height then
    win_row = win_row - height - 1
  end

  if win_col + width >= editor_width then
    win_col = editor_width - width - 1
  end

  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'win',
    row = win_row,
    col = win_col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'none',
    focusable = false,
  })

  vim.api.nvim_set_option_value('wrap', false, { win = win })
  vim.api.nvim_set_option_value('cursorline', false, { win = win })

  local group = vim.api.nvim_create_augroup('GitBlamePopup', { clear = true })
  vim.api.nvim_create_autocmd({
    'CursorMoved',
    'CursorMovedI',
    'BufLeave',
    'InsertEnter',
    'InsertLeave',
    'TextChanged',
    'TextChangedI',
  }, {
    group = group,
    buffer = vim.api.nvim_get_current_buf(),
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      vim.api.nvim_del_augroup_by_name 'GitBlamePopup'
    end,
    once = true,
  })
end

vim.api.nvim_create_user_command('CustomGitBlame', create_blame_popup, {})
