local scrollbar = { ' ', '▂', '▃', '▄', '▅', '▆', '▇', '█' }

local fmt, concat = string.format, table.concat
local function hl_str(group, text)
  return fmt('%%#%s#%s%%#StatusLine#', group, text)
end

local function mode_segment()
  local mode = vim.api.nvim_get_mode().mode
  local mode_map = { n = 'N', i = 'I', v = 'V', V = 'V', ['\22'] = 'V', c = 'C', s = 'S', R = 'R' }
  local mode_colors = {
    n = 'StatusModeNormal',
    i = 'StatusModeInsert',
    v = 'StatusModeVisual',
    V = 'StatusModeVisual',
    ['\22'] = 'StatusModeVisual',
    c = 'StatusModeCommand',
    R = 'StatusModeReplace',
  }

  local hl = mode_colors[mode] or mode_colors[mode:sub(1, 1)] or 'StatusModeOther'
  return hl_str(hl, ' ' .. (mode_map[mode] or mode:sub(1, 1):upper()) .. ' ')
end

local function smart_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name == '' then
    return '[No Name]'
  end

  if name:find('oil://', 1, true) then
    name = name:sub(7)
  end

  local parts = vim.split(vim.fn.fnamemodify(name, ':.'), '/')

  if #parts > 2 then
    for i = 1, #parts - 2 do
      local p = parts[i]
      if #p > 0 then
        parts[i] = p:sub(1, 1)
      end
    end
  end

  local file = parts[#parts]
  local fn, ext = file:match '^(.*)%.([^.]+)$'
  if fn and ext then
    parts[#parts] = fn .. '.' .. hl_str('StatusFiletype', ext)
  end

  return concat(parts, '/')
end

local function scroll_segment()
  local cur, total = vim.fn.line '.', vim.fn.line '$'
  local pct = math.floor((cur / (total > 0 and total or 1)) * 100 + 0.5)
  local idx = pct == 0 and 1 or math.ceil((pct / 100) * 7) + 1

  local hl = pct >= 67 and 'StatusScrollHigh' or (pct >= 34 and 'StatusScrollMid' or 'StatusScrollLow')
  return hl_str(hl, scrollbar[idx] .. scrollbar[idx])
end

_G.statusline_render = function()
  return table.concat({
    mode_segment(),
    smart_path(),
    '%=' .. fmt('%d lines', vim.api.nvim_buf_line_count(0)),
    scroll_segment(),
  }, ' ')
end

local function set_highlights()
  local dark = '#1e1f29'

  local function set_b(target, source)
    local hl = vim.api.nvim_get_hl(0, { name = source, link = false })
    vim.api.nvim_set_hl(0, target, { bg = hl.fg or '#ffffff', fg = dark, bold = true })
  end

  set_b('StatusModeNormal', 'Function')
  set_b('StatusModeInsert', 'String')
  set_b('StatusModeVisual', 'Statement')
  set_b('StatusModeCommand', 'WarningMsg')
  set_b('StatusModeReplace', 'ErrorMsg')
  set_b('StatusModeSelect', 'Constant')
  set_b('StatusModeOther', 'Normal')

  vim.api.nvim_set_hl(0, 'StatusScrollLow', { link = 'String' })
  vim.api.nvim_set_hl(0, 'StatusScrollMid', { link = 'WarningMsg' })
  vim.api.nvim_set_hl(0, 'StatusScrollHigh', { link = 'ErrorMsg' })
  vim.api.nvim_set_hl(0, 'StatusFiletype', { link = 'Float' })
end

vim.o.laststatus = 3
vim.o.statusline = '%!v:lua.statusline_render()'

set_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('custom_statusline', { clear = true }),
  callback = set_highlights,
})
