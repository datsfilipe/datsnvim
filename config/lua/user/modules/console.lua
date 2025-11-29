local M = {}

local state = {
  buf = nil,
  win = nil,
  job = nil,
  stdout = nil,
  stderr = nil,
  queue = {},
  flush_timer = nil,
}

local function reset_buffer()
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  local bo = vim.bo[state.buf]
  bo.modifiable = true
  bo.buftype = 'nofile'
  bo.swapfile = false
  bo.bufhidden = 'hide'
  bo.filetype = 'console'

  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {})
  bo.modifiable = false
end

local function ensure_window()
  reset_buffer()
  local height = math.max(6, math.floor(vim.o.lines * 0.45))

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_buf(state.win, state.buf)
    pcall(vim.api.nvim_win_set_height, state.win, height)
    return
  end

  vim.cmd(string.format('botright %dsplit', height))
  state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.win, state.buf)

  local wo = vim.wo[state.win]
  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = 'no'
  wo.wrap = false
  wo.cursorline = false
  wo.winfixheight = true

  vim.keymap.set('n', 'q', function()
    M.close()
  end, { buffer = state.buf, silent = true, nowait = true })
end

local function flush_queue()
  if #state.queue == 0 then
    return
  end

  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    state.queue = {}
    return
  end

  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, -1, -1, false, state.queue)
  vim.bo[state.buf].modifiable = false

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    local count = vim.api.nvim_buf_line_count(state.buf)
    vim.api.nvim_win_set_cursor(state.win, { count, 0 })
  end

  state.queue = {}
  state.flush_timer = nil
end

local function append(lines)
  if type(lines) == 'string' then
    lines = vim.split(lines, '\n', { plain = true })
  end
  if not lines or #lines == 0 then
    return
  end

  for _, line in ipairs(lines) do
    table.insert(state.queue, line)
  end

  if not state.flush_timer then
    state.flush_timer = vim.defer_fn(vim.schedule_wrap(flush_queue), 10)
  end
end

local function close_pipes()
  for _, pipe in ipairs { state.stdout, state.stderr } do
    if pipe and not pipe:is_closing() then
      pipe:close()
    end
  end
  state.stdout = nil
  state.stderr = nil
end

local function stop_job()
  if state.job and not state.job:is_closing() then
    pcall(state.job.kill, state.job, 'sigterm')
    state.job:close()
  end
  state.job = nil
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
  end
end

function M.run(cmdline)
  if not cmdline or cmdline == '' then
    vim.notify('ConsoleRun requires a command', vim.log.levels.WARN)
    return
  end

  local current_win = vim.api.nvim_get_current_win()

  ensure_window()

  if current_win ~= state.win and vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_set_current_win(current_win)
  end

  stop_job()
  close_pipes()

  state.queue = {}
  if state.flush_timer then
    state.flush_timer:close()
    state.flush_timer = nil
  end

  append { '$ ' .. cmdline }

  state.stdout = vim.uv.new_pipe(false)
  state.stderr = vim.uv.new_pipe(false)

  ---@diagnostic disable-next-line: missing-fields
  local handle, err = vim.uv.spawn('sh', {
    args = { '-c', cmdline },
    stdio = { nil, state.stdout, state.stderr },
  }, function(code, signal)
    close_pipes()
    if state.job and not state.job:is_closing() then
      state.job:close()
    end
    state.job = nil
    append { string.format('[exit %d signal %d]', code or -1, signal or -1) }
  end)

  if not handle then
    append { '[spawn failed] ' .. tostring(err) }
    return
  end

  state.job = handle

  local function on_read(err2, data)
    if err2 then
      append { '[error] ' .. err2 }
      return
    end
    if data then
      local lines = vim.split(data, '\n', { plain = true })
      if #lines > 0 and lines[#lines] == '' then
        table.remove(lines)
      end
      append(lines)
    end
  end

  state.stdout:read_start(on_read)
  state.stderr:read_start(on_read)
end

function M.setup()
  vim.api.nvim_create_user_command('ConsoleRun', function(opts)
    M.run(opts.args)
  end, { nargs = '+', complete = 'shellcmd' })

  vim.keymap.set(
    'n',
    ';q',
    M.close,
    { silent = true, desc = 'Close console window' }
  )
  vim.keymap.set('c', '<CR>', function()
    local cmdtype = vim.fn.getcmdtype()
    local cmdline = vim.fn.getcmdline()

    if cmdtype == ':' and cmdline:match '^!' then
      local command = cmdline:sub(2)

      vim.fn.histadd('cmd', cmdline)
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<C-c>', true, false, true),
        'n',
        false
      )

      vim.schedule(function()
        M.run(command)
      end)

      return ''
    end

    return '<CR>'
  end, { expr = true })
end

return M
