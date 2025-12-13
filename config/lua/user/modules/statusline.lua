local icons = require 'user.icons'

local scrollbar_blocks =
{ ' ', '▂', '▃', '▄', '▅', '▆', '▇', '█' }

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
  local hl = mode_hl[mode] or mode_hl[mode:sub(1, 1)] or 'StatusModeOther'
  return ' ' .. hl_str(hl, ' ' .. mode_char() .. ' ')
end

local function smart_path()
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)

  if name == '' then
    return '[NONE]'
  end

  if name:match '^oil://' then
    name = name:gsub('^oil://', '')
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

  return table.concat(parts, '/')
end

local function get_git_branch()
  local buf = vim.api.nvim_get_current_buf()
  local branch = vim.b[buf].gitsigns_head or vim.b[buf].git_branch

  if not branch or branch == '' then
    return nil
  end
  return hl_str('StatusBranch', '#' .. branch:upper())
end

local function line_count()
  local buf = vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_line_count(buf)
end

local function diag_str()
  local total = vim.diagnostic
      and vim.diagnostic.count
      and vim.diagnostic.count(0)
      or {}
  local err = total[vim.diagnostic.severity.ERROR] or 0
  local warn = total[vim.diagnostic.severity.WARN] or 0
  local hint = total[vim.diagnostic.severity.HINT] or 0
  local info = total[vim.diagnostic.severity.INFO] or 0

  local parts = {}

  if err > 0 then
    table.insert(
      parts,
      hl_str('DiagnosticError', icons.diagnostics.ERROR .. err)
    )
  end

  if warn > 0 then
    table.insert(
      parts,
      hl_str('DiagnosticWarn', icons.diagnostics.WARN .. warn)
    )
  end

  if hint > 0 then
    table.insert(
      parts,
      hl_str('DiagnosticHint', icons.diagnostics.HINT .. hint)
    )
  end

  if info > 0 then
    table.insert(
      parts,
      hl_str('DiagnosticInfo', icons.diagnostics.INFO .. info)
    )
  end

  if #parts == 0 then
    return ''
  end
  return table.concat(parts, '')
end

local function get_workspace_info()
  local branch = get_git_branch()
  if not branch or branch == '' then
    return nil
  end

  local diag = diag_str()
  local grouped_info = '['
      .. hl_str('StatusFiletype', vim.bo.filetype:upper() or 'NONE')
      .. ', '
      .. branch
  if diag ~= '' then
    grouped_info = grouped_info .. ', ' .. diag
  end

  return grouped_info .. ']'
end

local function scroll_segment()
  local cur = vim.fn.line '.'
  local total = math.max(vim.fn.line '$', 1)
  local pct = math.floor((cur / total) * 100 + 0.5)

  local idx = 1
  if pct > 0 then
    idx = math.ceil((pct / 100) * 7) + 1
  end

  local hl = 'StatusScrollLow'
  if pct >= 67 then
    hl = 'StatusScrollHigh'
  elseif pct >= 34 then
    hl = 'StatusScrollMid'
  end
  local block = scrollbar_blocks[idx] .. scrollbar_blocks[idx]
  return hl_str(hl, block)
end

local function render()
  local left_parts = { mode_segment(), smart_path(), get_workspace_info() }
  local left_filtered = {}
  for _, part in ipairs(left_parts) do
    if part and part ~= '' then
      table.insert(left_filtered, part)
    end
  end
  local left = table.concat(left_filtered, '  ')

  local lines = line_count()
  local right_parts = {
    string.format('%d lines', lines),
    scroll_segment(),
  }
  local right_filtered = {}
  for _, part in ipairs(right_parts) do
    if part and part ~= '' then
      table.insert(right_filtered, part)
    end
  end

  return table.concat({ left, '%=', table.concat(right_filtered, '  ') }, ' ')
end

---@diagnostic disable-next-line: duplicate-set-field
function _G.statusline_render()
  return render()
end

local function set_highlights()
  local dark_text = '#1e1f29'

  local function set_block(target, source)
    local hl = vim.api.nvim_get_hl(0, { name = source })
    local fg = hl.fg
    if not fg then
      hl = vim.api.nvim_get_hl(0, { name = source, link = false })
      ---@diagnostic disable-next-line: cast-local-type
      fg = hl.fg or '#ffffff'
    end
    vim.api.nvim_set_hl(0, target, { bg = fg, fg = dark_text, bold = true })
  end

  vim.api.nvim_set_hl(0, 'StatusScrollLow', { link = 'String' })
  vim.api.nvim_set_hl(0, 'StatusScrollMid', { link = 'WarningMsg' })
  vim.api.nvim_set_hl(0, 'StatusScrollHigh', { link = 'ErrorMsg' })
  vim.api.nvim_set_hl(0, 'StatusBranch', { link = 'DiagnosticError' })
  vim.api.nvim_set_hl(0, 'StatusFiletype', { link = 'Float' })

  set_block('StatusModeNormal', 'Function')
  set_block('StatusModeInsert', 'String')
  set_block('StatusModeVisual', 'Statement')
  set_block('StatusModeCommand', 'WarningMsg')
  set_block('StatusModeReplace', 'ErrorMsg')
  set_block('StatusModeSelect', 'Constant')
  set_block('StatusModeOther', 'Normal')
end

return {
  setup = function()
    vim.o.statusline = '%!v:lua.statusline_render()'
    set_highlights()

    local aug =
        vim.api.nvim_create_augroup('custom_statusline_simple', { clear = true })

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = aug,
      callback = set_highlights,
    })

    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'ModeChanged' }, {
      group = aug,
      callback = function()
        vim.cmd 'redrawstatus'
      end,
    })

    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'BufWritePost' }, {
      group = aug,
      callback = function()
        local handle = io.popen 'git branch --show-current 2> /dev/null'
        if handle then
          local result = handle:read '*a'
          handle:close()
          local branch = result:gsub('[\n\r]', '')
          if branch ~= '' then
            vim.b.git_branch = branch
          else
            vim.b.git_branch = nil
          end
        end
      end,
    })
  end,
}
