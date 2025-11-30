local M = {}

local api = vim.api
local uv = vim.uv
local split = vim.split
local tbl_insert = table.insert

local state = {
  buf = nil,
  win = nil,
  job = nil,
  stdout = nil,
  stderr = nil,
  queue = {},
  remainder = '',
  flush_timer = nil,
}

local function reset_buffer()
  if not (state.buf and api.nvim_buf_is_valid(state.buf)) then
    state.buf = api.nvim_create_buf(false, true)
  end

  local bo = vim.bo[state.buf]
  bo.modifiable = true
  bo.buftype = 'nofile'
  bo.swapfile = false
  bo.bufhidden = 'hide'
  bo.filetype = 'console'

  api.nvim_buf_set_lines(state.buf, 0, -1, false, {})
  bo.modifiable = false
end

local function ensure_window()
  reset_buffer()
  local height = math.max(6, math.floor(vim.o.lines * 0.45))

  if state.win and api.nvim_win_is_valid(state.win) then
    api.nvim_win_set_buf(state.win, state.buf)
    pcall(api.nvim_win_set_height, state.win, height)
    return
  end

  vim.cmd(string.format('botright %dsplit', height))
  state.win = api.nvim_get_current_win()
  api.nvim_win_set_buf(state.win, state.buf)

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
  state.flush_timer = nil
  local queue_len = #state.queue
  if queue_len == 0 then
    return
  end

  if not (state.buf and api.nvim_buf_is_valid(state.buf)) then
    state.queue = {}
    state.remainder = ''
    return
  end

  local bo = vim.bo[state.buf]
  bo.modifiable = true

  api.nvim_buf_set_lines(state.buf, -1, -1, false, state.queue)

  local total_lines = api.nvim_buf_line_count(state.buf)
  if total_lines > 10000 then
    api.nvim_buf_set_lines(state.buf, 0, total_lines - 9000, false, {})
  end

  bo.modifiable = false

  if state.win and api.nvim_win_is_valid(state.win) then
    local new_count = api.nvim_buf_line_count(state.buf)
    api.nvim_win_set_cursor(state.win, { new_count, 0 })
  end

  state.queue = {}
end

local function schedule_flush()
  if not state.flush_timer then
    state.flush_timer = vim.defer_fn(vim.schedule_wrap(flush_queue), 10)
  end
end

local function append_stream(data)
  if not data or data == '' then
    return
  end

  local text = state.remainder .. data
  if not text:find('\n', 1, true) then
    state.remainder = text
    return
  end

  local lines = split(text, '\n', { plain = true })
  state.remainder = lines[#lines]
  lines[#lines] = nil

  for _, line in ipairs(lines) do
    tbl_insert(state.queue, line)
  end

  schedule_flush()
end

local function append_direct(lines)
  for _, line in ipairs(lines) do
    tbl_insert(state.queue, line)
  end
  schedule_flush()
end

local function close_pipes()
  if state.stdout and not state.stdout:is_closing() then
    state.stdout:close()
  end
  if state.stderr and not state.stderr:is_closing() then
    state.stderr:close()
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
  stop_job()
  close_pipes()
  if state.win and api.nvim_win_is_valid(state.win) then
    api.nvim_win_close(state.win, true)
    state.win = nil
  end
end

function M.run(cmdline)
  if not cmdline or cmdline == '' then
    vim.notify('ConsoleRun requires a command', vim.log.levels.WARN)
    return
  end

  local current_win = api.nvim_get_current_win()
  ensure_window()

  if current_win ~= state.win and api.nvim_win_is_valid(current_win) then
    api.nvim_set_current_win(current_win)
  end

  stop_job()
  close_pipes()

  state.queue = {}
  state.remainder = ''
  if state.flush_timer then
    state.flush_timer:close()
    state.flush_timer = nil
  end

  append_direct { '$ ' .. cmdline }

  state.stdout = uv.new_pipe(false)
  state.stderr = uv.new_pipe(false)

  ---@diagnostic disable-next-line: missing-fields
  local handle, err = uv.spawn('sh', {
    args = { '-c', cmdline },
    stdio = { nil, state.stdout, state.stderr },
  }, function(code, signal)
    close_pipes()
    if state.job and not state.job:is_closing() then
      state.job:close()
    end

    state.job = nil

    if state.remainder ~= '' then
      table.insert(state.queue, state.remainder)
      state.remainder = ''
    end

    table.insert(
      state.queue,
      string.format('[exit %d signal %d]', code or -1, signal or -1)
    )
    vim.schedule(flush_queue)
  end)

  if not handle then
    append_direct { '[spawn failed] ' .. tostring(err) }
    return
  end

  state.job = handle

  local function on_read(err2, data)
    if err2 then
      append_direct { '[error] ' .. err2 }
      return
    end
    if data then
      append_stream(data)
    end
  end

  state.stdout:read_start(on_read)
  state.stderr:read_start(on_read)
end

function M.setup()
  api.nvim_create_user_command('ConsoleRun', function(opts)
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
      api.nvim_feedkeys(
        api.nvim_replace_termcodes('<C-c>', true, false, true),
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
