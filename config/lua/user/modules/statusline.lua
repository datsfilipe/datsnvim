local M = {}

local icons = require 'user.icons'
local scrollbar_blocks =
  { ' ', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
local fmt, insert, concat, floor =
  string.format, table.insert, table.concat, math.floor

local function hl_str(group, text)
  return fmt('%%#%s#%s%%#StatusLine#', group, text)
end

local function mode_segment()
  local mode = vim.api.nvim_get_mode().mode
  local mode_hl = {
    n = 'StatusModeNormal',
    i = 'StatusModeInsert',
    v = 'StatusModeVisual',
    V = 'StatusModeVisual',
    ['\22'] = 'StatusModeVisual',
    c = 'StatusModeCommand',
    s = 'StatusModeSelect',
    R = 'StatusModeReplace',
  }
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
  local hl = mode_hl[mode] or mode_hl[mode:sub(1, 1)] or 'StatusModeOther'
  return ' ' .. hl_str(hl, ' ' .. (map[mode] or mode:sub(1, 1):upper()) .. ' ')
end

local function smart_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name == '' then
    return '[NONE]'
  end
  if name:find('oil://', 1, true) then
    name = name:sub(7)
  end
  local path = vim.fn.fnamemodify(name, ':.')
  local parts = vim.split(path, '/')
  if #parts > 3 then
    for i = 1, #parts - 3 do
      local p = parts[i]
      if #p > 0 then
        parts[i] = p:sub(1, 1)
      end
    end
  end
  return concat(parts, '/')
end

local function diag_str()
  local total = vim.diagnostic.count(0)
  local parts = {}
  if total[1] then
    insert(
      parts,
      hl_str('DiagnosticError', icons.diagnostics.ERROR .. total[1])
    )
  end
  if total[2] then
    insert(parts, hl_str('DiagnosticWarn', icons.diagnostics.WARN .. total[2]))
  end
  if total[3] then
    insert(parts, hl_str('DiagnosticInfo', icons.diagnostics.INFO .. total[3]))
  end
  if total[4] then
    insert(parts, hl_str('DiagnosticHint', icons.diagnostics.HINT .. total[4]))
  end
  return #parts == 0 and '' or concat(parts, '')
end

local function get_workspace_info()
  local branch = vim.b.gitsigns_head or vim.b.git_branch
  if not branch then
    return nil
  end
  local diag = diag_str()
  local ft = vim.bo.filetype:upper()
  local base = '['
    .. hl_str('StatusFiletype', ft ~= '' and ft or 'NONE')
    .. ', '
    .. hl_str('StatusBranch', '#' .. branch:upper())
  return diag ~= '' and (base .. ', ' .. diag .. ']') or (base .. ']')
end

local function scroll_segment()
  local cur, total = vim.fn.line '.', vim.fn.line '$'
  local pct = floor((cur / (total > 0 and total or 1)) * 100 + 0.5)
  local idx = pct == 0 and 1 or math.ceil((pct / 100) * 7) + 1
  local hl = pct >= 67 and 'StatusScrollHigh'
    or (pct >= 34 and 'StatusScrollMid' or 'StatusScrollLow')
  return hl_str(hl, scrollbar_blocks[idx] .. scrollbar_blocks[idx])
end

_G.statusline_render = function()
  local left =
    concat({ mode_segment(), smart_path(), get_workspace_info() or '' }, '  ')
  local right = concat(
    { fmt('%d lines', vim.api.nvim_buf_line_count(0)), scroll_segment() },
    '  '
  )
  return left .. ' %=' .. right .. ' '
end

local function set_highlights()
  local dark = '#1e1f29'
  local function set_b(target, source)
    local hl = vim.api.nvim_get_hl(0, { name = source, link = false })
    vim.api.nvim_set_hl(
      0,
      target,
      { bg = hl.fg or '#ffffff', fg = dark, bold = true }
    )
  end
  vim.api.nvim_set_hl(0, 'StatusScrollLow', { link = 'String' })
  vim.api.nvim_set_hl(0, 'StatusScrollMid', { link = 'WarningMsg' })
  vim.api.nvim_set_hl(0, 'StatusScrollHigh', { link = 'ErrorMsg' })
  vim.api.nvim_set_hl(0, 'StatusBranch', { link = 'DiagnosticError' })
  vim.api.nvim_set_hl(0, 'StatusFiletype', { link = 'Float' })
  set_b('StatusModeNormal', 'Function')
  set_b('StatusModeInsert', 'String')
  set_b('StatusModeVisual', 'Statement')
  set_b('StatusModeCommand', 'WarningMsg')
  set_b('StatusModeReplace', 'ErrorMsg')
  set_b('StatusModeSelect', 'Constant')
  set_b('StatusModeOther', 'Normal')
end

vim.o.laststatus, vim.o.statusline = 3, '%!v:lua.statusline_render()'
set_highlights()
local aug = vim.api.nvim_create_augroup('custom_statusline', { clear = true })
vim.api.nvim_create_autocmd(
  'ColorScheme',
  { group = aug, callback = set_highlights }
)
vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'ModeChanged' }, {
  group = aug,
  callback = function()
    vim.cmd 'redrawstatus'
  end,
})
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'BufWritePost' }, {
  group = aug,
  callback = function()
    vim.system(
      { 'git', 'branch', '--show-current' },
      { text = true },
      function(out)
        if out.code == 0 then
          local branch = out.stdout:gsub('[\n\r]', '')
          vim.schedule(function()
            vim.b.git_branch = branch ~= '' and branch or nil
            vim.cmd 'redrawstatus'
          end)
        end
      end
    )
  end,
})
