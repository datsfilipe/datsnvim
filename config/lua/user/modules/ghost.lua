local utils = require 'user.utils'
local map = utils.map

local ns = vim.api.nvim_create_namespace 'user/ai_ghost'
local suggestion = nil
local timer = nil
local job = nil
local state_ver = 0

local API_URL = 'http://127.0.0.1:11434/api/generate'
local MODEL = 'qwen2.5-coder:1.5b'
local DEBOUNCE_MS = 75
local MAX_CONTEXT_LINES = 100
local MAX_SUGGESTION_LINES = 4

local function clear_ghost()
  if timer then
    if not timer:is_closing() then
      timer:close()
    end
    timer = nil
  end
  if job then
    pcall(function()
      job:kill()
    end)
    job = nil
  end
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  suggestion = nil
end

local function show_ghost(text)
  local mode = vim.api.nvim_get_mode().mode
  if mode ~= 'i' and mode ~= 'ic' and mode ~= 'ix' then
    return
  end

  if not text or text == '' then
    return
  end
  text = text:gsub('```%w*', ''):gsub('```', '')

  local lines = vim.split(text, '\n', { plain = true })
  if #lines > MAX_SUGGESTION_LINES then
    lines = vim.list_slice(lines, 1, MAX_SUGGESTION_LINES)
  end

  suggestion = table.concat(lines, '\n')

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

  if lines[1] and lines[1] ~= '' then
    vim.api.nvim_buf_set_extmark(0, ns, row - 1, col, {
      virt_text = { { lines[1], 'Comment' } },
      virt_text_pos = 'overlay',
      hl_mode = 'combine',
    })
  end

  if #lines > 1 then
    local virt_lines = {}
    for i = 2, #lines do
      table.insert(virt_lines, { { lines[i], 'Comment' } })
    end
    vim.api.nvim_buf_set_extmark(0, ns, row - 1, 0, {
      virt_lines = virt_lines,
      hl_mode = 'combine',
    })
  end
end

local function get_extra_context(current_buf)
  local extra = {}
  local bufs = vim.api.nvim_list_bufs()
  local count = 0
  for _, buf in ipairs(bufs) do
    if count >= 3 then
      break
    end
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, 50, false)
      if #lines > 0 then
        table.insert(
          extra,
          string.format('// File: %s\n%s', name, table.concat(lines, '\n'))
        )
        count = count + 1
      end
    end
  end
  return table.concat(extra, '\n\n')
end

local function get_context(row, col)
  local ok, result = pcall(function()
    local before = vim.api.nvim_buf_get_text(
      0,
      math.max(0, row - MAX_CONTEXT_LINES),
      0,
      row - 1,
      col,
      {}
    )
    local after = vim.api.nvim_buf_get_text(
      0,
      row - 1,
      col,
      math.min(vim.api.nvim_buf_line_count(0), row + MAX_CONTEXT_LINES),
      0,
      {}
    )
    return { before, after }
  end)

  if not ok then
    return nil, nil
  end
  return result[1], result[2]
end

local function fetch_completion()
  local current_ver = state_ver
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_buf = vim.api.nvim_get_current_buf()

  local before, after = get_context(row, col)
  if not before or not after then
    return
  end

  local extra_context = get_extra_context(current_buf)
  local prompt = string.format(
    '%s\n<|fim_prefix|>%s<|fim_suffix|>%s<|fim_middle|>',
    extra_context,
    table.concat(before, '\n'),
    table.concat(after, '\n')
  )

  local payload = {
    model = MODEL,
    prompt = prompt,
    raw = true,
    stream = true,
    keep_alive = -1,
    options = {
      num_predict = 128,
      temperature = 0.1,
      stop = { '<|file_separator|>' },
    },
  }

  local current_suggestion = ''

  job = vim.system(
    { 'curl', '-s', '-N', API_URL, '-d', vim.json.encode(payload) },
    {
      stdout = function(_, data)
        if not data then
          return
        end
        vim.schedule(function()
          if state_ver ~= current_ver then
            return
          end

          for line in data:gmatch '[^\r\n]+' do
            local ok, json = pcall(vim.json.decode, line)
            if ok and json.response then
              current_suggestion = current_suggestion .. json.response

              local _, newlines = current_suggestion:gsub('\n', '\n')
              if newlines >= MAX_SUGGESTION_LINES then
                if job then
                  pcall(function()
                    job:kill()
                  end)
                end
                job = nil
              end

              show_ghost(current_suggestion)
            end
            if ok and json.done then
              job = nil
            end
          end
        end)
      end,
    }
  )
end

vim.api.nvim_create_autocmd({ 'TextChangedI', 'CursorMovedI' }, {
  callback = function()
    state_ver = state_ver + 1
    clear_ghost()
    timer = vim.defer_fn(fetch_completion, DEBOUNCE_MS)
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    clear_ghost()
    state_ver = state_ver + 1
  end,
})

map('i', '<C-g>', function()
  if not suggestion then
    return
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  local lines = vim.split(suggestion, '\n', { plain = true })
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, lines)

  local new_row = row + #lines - 1
  local new_col
  if #lines == 1 then
    new_col = col + #lines[1]
  else
    new_col = #lines[#lines]
  end

  vim.api.nvim_win_set_cursor(0, { new_row, new_col })
  clear_ghost()
end, utils.map_options)
