local M = {}

local ignore_dirs = { '.git', 'node_modules', '.cache', '.next', '.nuxt', 'dist', 'build', 'target', 'out', '.cargo', 'vendor', '.vscode' }

local ns = vim.api.nvim_create_namespace('picker_ns')

local state = {
  win_id = nil,
  buf_id = nil,
  job_id = nil,
  debounce_timer = nil,
  selected_line = 1,
  selected_char = '>',
  results = {},
  full_results = {},
  mode = nil,
  shorten_cache = {},
  current_input = '',
  git_files_cache = nil,
  open_buffers_cache = nil,
}

local config = {
  window = { width_ratio = 0.5, height_ratio = 0.6, col_ratio = 0.5, row_ratio = 0.5 },
  highlights = { prompt_and_selected = 'DPrimary' },
  debounce_ms = 100,
}

local is_setup = false

local function lazy_setup()
  if is_setup then return end
  vim.api.nvim_set_hl(0, config.highlights.prompt_and_selected, { fg = '#89B4FA', bg = '#313244', bold = true })
  is_setup = true
end

local function shrink_path(path)
  if state.shorten_cache[path] then return state.shorten_cache[path] end
  local sep = package.config:sub(1, 1)
  local home = os.getenv 'HOME'
  if home and path:find(home, 1, true) == 1 then path = path:gsub(home, '~', 1) end
  local parts = {}
  for p in path:gmatch('([^' .. sep .. ']+)') do parts[#parts + 1] = p end
  if #parts <= 3 then
    state.shorten_cache[path] = path
    return path
  end
  local out = {}
  for i = 1, #parts do
    if i < #parts - 1 and #parts > 4 then
      out[#out + 1] = (i > 1) and parts[i]:sub(1, 1) or parts[i]
    else
      out[#out + 1] = parts[i]
    end
  end
  local res = table.concat(out, sep)
  state.shorten_cache[path] = res
  return res
end

local function levenshtein_distance(s1, s2)
  local len1, len2 = #s1, #s2
  if len1 < len2 then
    s1, s2 = s2, s1
    len1, len2 = len2, len1
  end

  if len2 == 0 then return len1 end

  local v0 = {}
  for i = 0, len2 do v0[i] = i end

  local v1 = {}
  for i = 1, len1 do
    v1[0] = i
    for j = 1, len2 do
      local cost = (s1:sub(i, i) == s2:sub(j, j)) and 0 or 1
      v1[j] = math.min(v1[j - 1] + 1, v0[j] + 1, v0[j - 1] + cost)
    end
    for k = 0, len2 do v0[k] = v1[k] end
  end

  return v0[len2]
end

local function get_git_modified_files()
  local h = io.popen('git diff --name-only 2>/dev/null')
  if not h then return {} end
  local t = {}
  for l in h:lines() do t[l] = true end
  h:close()
  return t
end

local function get_open_buffers()
  local t = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) then
      local n = vim.api.nvim_buf_get_name(b)
      if n and n ~= '' then t[n] = true end
    end
  end
  return t
end

local function rank_results(results, input)
  if not input or input == '' then return results end
  local il = input:lower()

  if not state.git_files_cache then state.git_files_cache = get_git_modified_files() end
  if not state.open_buffers_cache then state.open_buffers_cache = get_open_buffers() end
  local git_files = state.git_files_cache
  local open_buffers = state.open_buffers_cache

  local ranked = {}
  for _, r in ipairs(results) do
    local filename = r:match('[^/]+$') or r
    local fl, fn = r:lower(), filename:lower()
    if not fl:find(il, 1, true) then goto continue end
    local score = 0

    if fn == il or fl == il then score = score + 1000 end
    if fn:sub(1, #il) == il then score = score + 600 end
    if fn:find(il, 1, true) then score = score + 400 end
    if fl:find(il, 1, true) then score = score + 200 end

    if #il >= 3 then
      local ld = levenshtein_distance(fn, il)
      if ld <= 2 then score = score + (800 - ld * 50) end
    end

    if git_files[r] then score = score + 100 end
    if open_buffers[r] then score = score + 50 end

    ranked[#ranked + 1] = { result = r, score = score }
    ::continue::
  end
  table.sort(ranked, function(a, b) return a.score > b.score end)
  local out = {}
  for i = 1, #ranked do out[i] = ranked[i].result end
  return out
end

local function create_window()
  local width = math.floor(vim.o.columns * config.window.width_ratio)
  local height = math.floor(vim.o.lines * config.window.height_ratio)

  local col = 0
  local row = vim.o.lines - height - vim.o.cmdheight - 1

  state.buf_id = vim.api.nvim_create_buf(false, true)
  state.win_id = vim.api.nvim_open_win(state.buf_id, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'none',
  })

  vim.wo[state.win_id].winhl = 'Normal:Normal'
  vim.wo[state.win_id].cursorline = false
  vim.wo[state.win_id].number = false
  vim.wo[state.win_id].relativenumber = false
  vim.wo[state.win_id].signcolumn = 'no'

  vim.bo[state.buf_id].bufhidden = 'wipe'
  vim.bo[state.buf_id].swapfile = false
  vim.bo[state.buf_id].buftype = 'nofile'
end

local function update_results_display()
  if not state.buf_id or not vim.api.nvim_buf_is_valid(state.buf_id) then return end
  local prev_mod = vim.bo[state.buf_id].modifiable
  vim.bo[state.buf_id].modifiable = true
  vim.api.nvim_buf_clear_namespace(state.buf_id, ns, 0, -1)
  local lines = {}
  lines[#lines + 1] = state.current_input
  for _, r in ipairs(state.results) do
    local line
    if state.mode == 'files' then
      line = '  ' .. shrink_path(r)
    elseif state.mode == 'grep' then
      local parts = vim.split(r, ':', { plain = true, trimempty = true })
      if #parts >= 3 then
        line = string.format('  %s:%s: %s', shrink_path(parts[1]), parts[2], table.concat(parts, ':', 3))
      else
        line = '  ' .. r
      end
    else
      line = '  ' .. r
    end
    lines[#lines + 1] = line
  end

  local prev_eventignore = vim.o.eventignore
  vim.o.eventignore = 'all'
  vim.api.nvim_buf_set_lines(state.buf_id, 0, -1, false, lines)
  vim.o.eventignore = prev_eventignore

  if #state.results == 0 then
    state.selected_line = 1
  else
    if state.selected_line < 1 then state.selected_line = 1 end
    if state.selected_line > #state.results then state.selected_line = #state.results end
  end

  if #state.results > 0 and state.selected_line <= #state.results then
    local buf = state.buf_id
    local target = state.selected_line
    pcall(vim.api.nvim_buf_set_text, buf or 0, target, 0, target, 2, { state.selected_char .. ' ' })
    vim.api.nvim_buf_clear_namespace(buf or 0, ns, 0, -1)

    local line_text = vim.api.nvim_buf_get_lines(buf or 0, target, target + 1, false)[1] or ''
    local end_col = #line_text

    if vim.hl and vim.hl.range then
      local ok, _ = pcall(
        vim.hl.range,
        buf,
        ns,
        config.highlights.prompt_and_selected,
        { target, 0 },
        { target, end_col },
        { inclusive = true, priority = vim.hl.priorities.user }
      )
      if ok then
        vim.bo[state.buf_id].modifiable = prev_mod
        if vim.api.nvim_win_is_valid(state.win_id) then vim.api.nvim_win_set_cursor(state.win_id, { 1, #state.current_input }) end
        return
      end
    end

    pcall(vim.api.nvim_buf_set_extmark, buf, ns, target, 0, {
      hl_group = config.highlights.prompt_and_selected,
      hl_eol = true,
      priority = 200,
    })
  end

  vim.bo[state.buf_id].modifiable = prev_mod
  if vim.api.nvim_win_is_valid(state.win_id) then vim.api.nvim_win_set_cursor(state.win_id, { 1, #state.current_input }) end
end

function M.close()
  if state.job_id then vim.loop.kill(state.job_id, 'SIGTERM'); state.job_id = nil end
  if state.debounce_timer then state.debounce_timer:stop(); state.debounce_timer:close(); state.debounce_timer = nil end
  if state.win_id and vim.api.nvim_win_is_valid(state.win_id) then vim.api.nvim_win_close(state.win_id, true) end
  state.win_id = nil
  state.buf_id = nil
  state.selected_line = 1
  state.results = {}
  state.full_results = {}
  state.shorten_cache = {}
  state.current_input = ''
  state.git_files_cache = nil
  state.open_buffers_cache = nil
  vim.cmd 'stopinsert'
end

local function on_select()
  local sel = state.results[state.selected_line]
  if not sel then
    M.close()
    return
  end
  M.close()
  if state.mode == 'files' then
    vim.cmd('edit ' .. vim.fn.fnameescape(sel))
  elseif state.mode == 'grep' then
    local parts = vim.split(sel, ':', { plain = true, trimempty = true })
    if #parts >= 2 then vim.cmd('edit +' .. parts[2] .. ' ' .. vim.fn.fnameescape(parts[1])) end
  elseif state.mode == 'highlights' then
    local hl = sel:match '%S+'
    if hl then
      vim.cmd('hi ' .. hl)
      vim.notify('Highlight applied: ' .. hl)
    end
  end
end

local function run_command(cmd, on_done)
  if state.job_id then vim.loop.kill(state.job_id, 'SIGTERM'); state.job_id = nil end
  local results = {}
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local args = {}
  for i = 2, #cmd do args[#args + 1] = cmd[i] end
  local handle = vim.loop.spawn(cmd[1], { args = args, stdio = { nil, stdout, stderr } }, function()
    if stdout then stdout:close() end
    if stderr then stderr:close() end
    if handle then handle:close() end
    state.job_id = nil
    if on_done then on_done(results) end
  end)
  if not handle then
    M.close()
    vim.notify('Error spawning process: ' .. cmd[1], vim.log.levels.ERROR)
    return
  end
  state.job_id = handle

  if stdout then
    local stdout_buf = ''
    vim.loop.read_start(stdout, function(err, data)
      if err or not data then return end
      stdout_buf = stdout_buf .. data
      local start_pos = 1
      while true do
        local end_pos = stdout_buf:find('\n', start_pos, true)
        if not end_pos then break end
        local line = stdout_buf:sub(start_pos, end_pos - 1)
        if line ~= '' then results[#results + 1] = line end
        start_pos = end_pos + 1
      end
      if start_pos > 1 then stdout_buf = stdout_buf:sub(start_pos) end
    end)
  end

  if stderr then
    vim.loop.read_start(stderr, function() end)
  end
end

local function handle_input_change()
  if state.mode == 'files' then
    if state.current_input == '' then
      state.results = vim.list_slice(state.full_results, 1, 100)
    else
      state.results = vim.list_slice(rank_results(state.full_results, state.current_input), 1, 100)
    end
    state.selected_line = math.min(state.selected_line, math.max(1, #state.results))
    update_results_display()
  elseif state.mode == 'grep' then
    if #state.current_input > 2 then
      run_command({ 'rg', '--line-number', '--color=never', state.current_input }, function(res)
        if state.mode == 'grep' then
          state.results = vim.list_slice(res, 1, 100)
          state.selected_line = 1
          vim.schedule(update_results_display)
        end
      end)
    else
      state.results = {}
      state.selected_line = 1
      update_results_display()
    end
  elseif state.mode == 'highlights' or state.mode == 'keymaps' then
    if state.current_input == '' then
      state.results = state.full_results
    else
      local il = state.current_input:lower()
      state.results = {}
      for _, r in ipairs(state.full_results) do
        if r:lower():find(il, 1, true) then state.results[#state.results + 1] = r end
      end
    end
    state.selected_line = math.min(state.selected_line, math.max(1, #state.results))
    update_results_display()
  end
end

local function debounce(fn, delay)
  return function(...)
    local args = { ... }
    if state.debounce_timer then state.debounce_timer:stop(); state.debounce_timer:close(); state.debounce_timer = nil end
    state.debounce_timer = vim.loop.new_timer()
    state.debounce_timer:start(delay, 0, function()
      if state.debounce_timer then state.debounce_timer:stop(); state.debounce_timer:close(); state.debounce_timer = nil end
      fn(unpack(args))
    end)
  end
end

local function cycle_selected(delta)
  local n = #state.results
  if n == 0 then return end
  local s = state.selected_line or 1
  s = ((s - 1 + delta) % n) + 1
  state.selected_line = s
  update_results_display()
end

local function send_to_quickfix(items)
  if not items or #items == 0 then
    vim.notify('No items to send to quickfix', vim.log.levels.WARN)
    return
  end
  local qf = {}
  for _, it in ipairs(items) do
    if state.mode == 'files' then
      qf[#qf + 1] = { filename = it, lnum = 1, col = 1, text = it }
    elseif state.mode == 'grep' then
      local parts = vim.split(it, ':', { plain = true, trimempty = true })
      if #parts >= 2 then
        local fname = parts[1]
        local lnum = tonumber(parts[2]) or 1
        local rest = (#parts >= 3) and table.concat(parts, ':', 3) or ''
        qf[#qf + 1] = { filename = fname, lnum = lnum, col = 1, text = rest ~= '' and rest or it }
      else
        qf[#qf + 1] = { filename = it, lnum = 1, col = 1, text = it }
      end
    else
      qf[#qf + 1] = { filename = '', lnum = 1, col = 1, text = it }
    end
  end
  vim.fn.setqflist({}, ' ', { title = 'Picker Quickfix', items = qf })
  M.close()
  vim.cmd('copen')
  vim.notify(('Sent %d items to quickfix'):format(#qf))
end

local function setup_keymaps()
  local buf = state.buf_id
  local map = function(mode, lhs, fn) vim.keymap.set(mode, lhs, fn, { buffer = buf, noremap = true, silent = true }) end
  map('i', '<Esc>', M.close)
  map('i', '<C-c>', M.close)
  map('i', '<CR>', on_select)
  map('n', '<Esc>', M.close)
  map('n', '<C-c>', M.close)
  map('n', '<CR>', on_select)

  map('i', '<Down>', function() cycle_selected(1) end)
  map('i', '<C-n>', function() cycle_selected(1) end)
  map('i', '<Up>', function() cycle_selected(-1) end)
  map('i', '<C-p>', function() cycle_selected(-1) end)
  map('n', '<Down>', function() cycle_selected(1) end)
  map('n', '<Up>', function() cycle_selected(-1) end)

  map('i', '<C-d>', function() cycle_selected(4) end)
  map('i', '<C-u>', function() cycle_selected(-4) end)
  map('n', '<C-d>', function() cycle_selected(4) end)
  map('n', '<C-u>', function() cycle_selected(-4) end)

  map('i', '<C-l>', function()
    if #state.results == 0 then
      vim.notify('No items to send to quickfix', vim.log.levels.WARN)
      return
    end
    send_to_quickfix(state.results)
  end)
  map('n', '<C-l>', function()
    if #state.results == 0 then
      vim.notify('No items to send to quickfix', vim.log.levels.WARN)
      return
    end
    send_to_quickfix(state.results)
  end)
end

function M.open(mode)
  lazy_setup()
  if state.win_id then M.close() end
  state.mode = mode
  state.current_input = ''
  state.results = {}
  state.full_results = {}
  state.selected_line = 1
  create_window()
  setup_keymaps()
  vim.api.nvim_buf_set_lines(state.buf_id, 0, -1, false, { '' })

  local function attach_input_handler()
    local deb = debounce(function()
      vim.schedule(function()
        if state.buf_id and vim.api.nvim_buf_is_valid(state.buf_id) then
          local lines = vim.api.nvim_buf_get_lines(state.buf_id, 0, 1, false)
          local new_input = lines[1] or ''
          if new_input ~= state.current_input then
            state.current_input = new_input
            handle_input_change()
          end
        end
      end)
    end, config.debounce_ms)
    vim.api.nvim_buf_attach(state.buf_id, false, { on_lines = function() deb() end })
  end

  if mode == 'files' then
    local cmd
    if vim.fn.executable 'fd' == 1 then
      cmd = { 'fd', '--type', 'f', '--hidden' }
      for _, d in ipairs(ignore_dirs) do cmd[#cmd + 1] = '--exclude'; cmd[#cmd + 1] = d end
    elseif vim.fn.executable 'rg' == 1 then
      cmd = { 'rg', '--files', '--hidden' }
      for _, d in ipairs(ignore_dirs) do cmd[#cmd + 1] = '--glob'; cmd[#cmd + 1] = '!' .. d end
    else
      M.close()
      vim.notify('fd or rg not found.', vim.log.levels.ERROR)
      return
    end
    attach_input_handler()
    run_command(cmd, function(results)
      if state.mode == 'files' then
        state.full_results = results
        state.results = vim.list_slice(results, 1, 100)
        state.selected_line = 1
        vim.schedule(update_results_display)
      end
    end)
  elseif mode == 'grep' then
    attach_input_handler()
  elseif mode == 'highlights' then
    local out = vim.api.nvim_exec2('silent! hi', { output = true }).output
    for _, l in ipairs(vim.split(out, '\n')) do
      if #l > 0 and not l:match '^xxx' then state.full_results[#state.full_results + 1] = l; state.results[#state.results + 1] = l end
    end
    attach_input_handler()
  elseif mode == 'keymaps' then
    local out = vim.api.nvim_exec2('silent! map', { output = true }).output
    for _, l in ipairs(vim.split(out, '\n')) do
      if #l > 0 then state.full_results[#state.full_results + 1] = l; state.results[#state.results + 1] = l end
    end
    attach_input_handler()
  end

  update_results_display()
  vim.cmd 'startinsert'
  if vim.api.nvim_win_is_valid(state.win_id) then vim.api.nvim_win_set_cursor(state.win_id, { 1, 0 }) end
end

M.setup = function()
  vim.api.nvim_create_user_command('Pick', function(opts) require('extensions.picker').open(opts.fargs[1]) end, {
    nargs = 1,
    complete = function() return { 'files', 'grep', 'highlights', 'keymaps' } end,
  })
  vim.keymap.set('n', ';f', function() require('extensions.picker').open 'files' end, { desc = 'Pick Files' })
  vim.keymap.set('n', ';r', function() require('extensions.picker').open 'grep' end, { desc = 'Pick Grep' })
  vim.keymap.set('n', ';h', function() require('extensions.picker').open 'highlights' end, { desc = 'Pick Highlights' })
  vim.keymap.set('n', ';k', function() require('extensions.picker').open 'keymaps' end, { desc = 'Pick Keymaps' })
end

return M
