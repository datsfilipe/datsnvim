local utils = require 'user.utils'
local map = utils.map

local ns = vim.api.nvim_create_namespace 'ai_ghost'
local suggestion = nil
local timer = nil
local job = nil
local state_ver = 0

local API_URL = 'http://127.0.0.1:11434/api/generate'
local MODEL = 'qwen2.5-coder:1.5b'

local function clear_ghost()
  if timer then
    if not timer:is_closing() then
      timer:close()
    end
    timer = nil
  end
  if job then
    job:kill()
    job = nil
  end
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  suggestion = nil
end

local function show_ghost(text)
  if vim.fn.mode() ~= 'i' or not text or text == '' then
    return
  end
  text = text:gsub('```%w*', ''):gsub('```', '')
  if text:match '^%s*$' then
    return
  end

  suggestion = text
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_extmark(0, ns, row - 1, col, {
    virt_text = { { text, 'Comment' } },
    virt_text_pos = 'overlay',
    hl_mode = 'combine',
  })
end

local function get_context(row, col)
  local ok, result = pcall(function()
    local before =
      vim.api.nvim_buf_get_text(0, math.max(0, row - 60), 0, row - 1, col, {})
    local after = vim.api.nvim_buf_get_text(
      0,
      row - 1,
      col,
      math.min(vim.api.nvim_buf_line_count(0), row + 60),
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

  local before, after = get_context(row, col)
  if not before or not after then
    return
  end

  local payload = {
    model = MODEL,
    prompt = '<|fim_prefix|>'
      .. table.concat(before, '\n')
      .. '<|fim_suffix|>'
      .. table.concat(after, '\n')
      .. '<|fim_middle|>',
    raw = true,
    stream = false,
    options = {
      num_predict = 50,
      stop = { '\n', '<|file_separator|>' },
      temperature = 0.1,
    },
  }

  job = vim.system(
    { 'curl', '-s', API_URL, '-d', vim.json.encode(payload) },
    { text = true },
    function(out)
      if state_ver ~= current_ver then
        return
      end
      job = nil
      if out.code == 0 then
        local ok, res = pcall(vim.json.decode, out.stdout)
        if ok and res.response then
          vim.schedule(function()
            if state_ver == current_ver then
              show_ghost(res.response)
            end
          end)
        end
      end
    end
  )
end

vim.api.nvim_create_autocmd({ 'TextChangedI', 'CursorMovedI' }, {
  callback = function()
    state_ver = state_ver + 1
    clear_ghost()
    timer = vim.defer_fn(fetch_completion, 500)
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', { callback = clear_ghost })

map('i', '<C-g>', function()
  if not suggestion then
    return
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { suggestion })
  vim.api.nvim_win_set_cursor(0, { row, col + #suggestion })
  clear_ghost()
end, utils.map_options)
