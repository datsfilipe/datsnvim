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
local MAX_CONTEXT_LINES = 60

local function log_msg(msg)
  vim.notify('ghost: ' .. msg, vim.log.levels.INFO)
end

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

  local line = vim.split(text, '\n', { plain = true })[1]
  if not line or line == '' then
    return
  end

  suggestion = line

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

  vim.api.nvim_buf_set_extmark(0, ns, row - 1, col, {
    virt_text = { { line, 'Comment' } },
    virt_text_pos = 'overlay',
    hl_mode = 'combine',
  })
end

local function get_context(row, col)
  local ok, result = pcall(function()
    local line_count = vim.api.nvim_buf_line_count(0)
    local line_idx = row - 1

    local start_line = math.max(0, line_idx - MAX_CONTEXT_LINES)
    local before_lines =
      vim.api.nvim_buf_get_lines(0, start_line, line_idx, false)

    local current_line = vim.api.nvim_buf_get_lines(
      0,
      line_idx,
      line_idx + 1,
      false
    )[1] or ''
    local prefix = current_line:sub(1, col)
    local suffix = current_line:sub(col + 1)

    local end_line = math.min(line_count, line_idx + 1 + MAX_CONTEXT_LINES)
    local after_lines =
      vim.api.nvim_buf_get_lines(0, line_idx + 1, end_line, false)

    table.insert(before_lines, prefix)
    table.insert(after_lines, 1, suffix)

    return { before_lines, after_lines }
  end)

  if not ok then
    log_msg('get_context failed: ' .. tostring(result))
    return nil, nil
  end
  return result[1], result[2]
end

local function fetch_completion()
  local current_ver = state_ver
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  local before, after = get_context(row, col)
  if not before or not after then
    return
  end

  local file_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  local file_header = '// File: ' .. file_path .. '\n'

  local prompt = '<|fim_prefix|>'
    .. file_header
    .. table.concat(before, '\n')
    .. '<|fim_suffix|>'
    .. table.concat(after, '\n')
    .. '<|fim_middle|>'

  local payload = {
    model = MODEL,
    prompt = prompt,
    raw = true,
    stream = true,
    keep_alive = -1,
    options = {
      num_predict = 128,
      temperature = 0.1,
      num_ctx = 8192,
      stop = { '<|file_separator|>', '\n' },
    },
  }

  local current_suggestion = ''
  local output_buffer = ''

  job = vim.system({ 'curl', '-s', '-N', API_URL, '-d', '@-' }, {
    stdin = vim.json.encode(payload),
    stderr = function(_, data)
      if data then
        log_msg('curl err: ' .. data)
      end
    end,
    stdout = function(_, data)
      if not data then
        return
      end
      vim.schedule(function()
        if state_ver ~= current_ver then
          return
        end

        output_buffer = output_buffer .. data

        while true do
          local newline_idx = output_buffer:find '\n'
          if not newline_idx then
            break
          end

          local line = output_buffer:sub(1, newline_idx - 1)
          output_buffer = output_buffer:sub(newline_idx + 1)

          local ok, json = pcall(vim.json.decode, line)
          if ok and json.response then
            if json.response:find '\n' then
              if job then
                pcall(function()
                  job:kill()
                end)
              end
              job = nil
              return
            end

            current_suggestion = current_suggestion .. json.response
            show_ghost(current_suggestion)
          end
          if ok and json.done then
            job = nil
          end
        end
      end)
    end,
  })
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

  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { suggestion })
  vim.api.nvim_win_set_cursor(0, { row, col + #suggestion })

  clear_ghost()
end, utils.map_options)
