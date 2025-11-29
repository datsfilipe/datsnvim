local M = {}

local scrollbar_blocks =
  { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }

local function hl_str(group, text)
  return string.format('%%#%s#%s%%#StatusLine#', group, text)
end

local function mode_char()
  local mode = vim.api.nvim_get_mode().mode
  local map = {
    n = 'N',
    i = 'I',
    v = 'V',
    V = 'V',
    ['\22'] = 'V',
    c = 'C',
    s = 'S',
    R = 'R',
  }
  return map[mode] or mode:sub(1, 1):upper()
end

local function shorten_path(path, max_width)
  if not path or path == '' then
    return '[_]'
  end
  local display = vim.fn.fnamemodify(path, ':~')
  if vim.fn.strwidth(display) <= max_width then
    return display
  end
  return vim.fn.pathshorten(display)
end

local function counts()
  local buf = vim.api.nvim_get_current_buf()
  local wc = vim.fn.wordcount()
  local lines = vim.api.nvim_buf_line_count(buf)
  local words = wc.words or 0
  local chars = wc.chars or wc.bytes or 0
  return lines, words, chars
end

local function diag_str()
  local total = vim.diagnostic
      and vim.diagnostic.count
      and vim.diagnostic.count(0)
    or {}
  local err = total[vim.diagnostic.severity.ERROR] or 0
  local warn = total[vim.diagnostic.severity.WARN] or 0
  if err == 0 and warn == 0 then
    return ''
  end
  return string.format('x %d ! %d', err, warn)
end

local function scroll_segment()
  local cur = vim.fn.line '.'
  local total = math.max(vim.fn.line '$', 1)
  local pct = math.floor((cur / total) * 100 + 0.5)
  local idx = math.min(
    #scrollbar_blocks,
    math.max(1, math.floor((pct / 100) * #scrollbar_blocks))
  )
  local hl = 'StatusScrollLow'
  if pct >= 67 then
    hl = 'StatusScrollHigh'
  elseif pct >= 34 then
    hl = 'StatusScrollMid'
  end
  local block = scrollbar_blocks[idx] .. scrollbar_blocks[idx]
  return hl_str(hl, block) .. string.format(' %3d%%', pct)
end

local function render()
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  local left = string.format('%s   %s', mode_char(), shorten_path(name, 70))

  local lines, words, chars = counts()
  local diag = diag_str()
  local right_parts = {
    diag ~= '' and diag or '-',
    string.format('%d lines %d words %d chars', lines, words, chars),
    scroll_segment(),
  }

  local filtered = {}
  for _, part in ipairs(right_parts) do
    if part and part ~= '' then
      table.insert(filtered, part)
    end
  end

  return table.concat({ left, '%=', table.concat(filtered, '  ') }, ' ')
end

function _G.statusline_render()
  return render()
end

local function set_highlights()
  vim.api.nvim_set_hl(
    0,
    'StatusScrollLow',
    { fg = '#50fa7b', bg = 'NONE', bold = true }
  )
  vim.api.nvim_set_hl(
    0,
    'StatusScrollMid',
    { fg = '#f1fa8c', bg = 'NONE', bold = true }
  )
  vim.api.nvim_set_hl(
    0,
    'StatusScrollHigh',
    { fg = '#ff5555', bg = 'NONE', bold = true }
  )
end

function M.setup()
  vim.o.statusline = '%!v:lua.statusline_render()'
  set_highlights()

  local aug =
    vim.api.nvim_create_augroup('custom_statusline_simple', { clear = true })
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd({
    'BufEnter',
    'BufLeave',
    'CursorMoved',
    'ModeChanged',
    'DiagnosticChanged',
    'BufWritePost',
    ---@diagnostic disable-next-line: assign-type-mismatch
    'WinEnter',
    ---@diagnostic disable-next-line: assign-type-mismatch
    'WinLeave',
  }, {
    group = aug,
    callback = function()
      vim.o.statusline = '%!v:lua.statusline_render()'
    end,
  })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = aug,
    callback = set_highlights,
  })
end

return M
