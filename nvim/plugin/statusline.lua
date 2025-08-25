local diagnostics = require('icons').diagnostics
local stl_parts = {
  mode = nil,
  buf_info = nil,
  diag = nil,
  git_info = nil,
  modifiable = nil,
  modified = nil,
  pad = ' ',
  path = nil,
  ro = nil,
  scrollbar = nil,
  sep = '%=',
  trunc = '%<',
}

local cache = {
  git_root = nil,
  git_branch = nil,
  git_check_time = 0,
  path_info = {},
  diag_count = {},
  diag_check_time = 0,
  wordcount = {},
  wordcount_buf_tick = {},
}

local GIT_CACHE_TTL = 5000
local DIAG_CACHE_TTL = 1000
local str_table = {}

local function ordered_tbl_concat(order_tbl, stl_part_tbl)
  for i = 1, #str_table do
    str_table[i] = nil
  end
  for _, val in ipairs(order_tbl) do
    local part = stl_part_tbl[val]
    if part and part ~= '' then
      table.insert(str_table, part)
    end
  end
  return table.concat(str_table, ' ')
end

local function hl_str(hl_group, str)
  return string.format('%%#%s#%s%%', hl_group, str)
end

local mode_cache = {
  n = { char = 'N', group = 'Cursor' },
  v = { char = 'V', group = 'DiagnosticWarnLn' },
  V = { char = 'V', group = 'DiagnosticWarnLn' },
  ['\22'] = { char = 'V', group = 'DiagnosticWarnLn' },
  i = { char = 'I', group = 'DiagnosticInfoLn' },
  c = { char = 'C', group = 'DiagnosticErrorLn' },
}

local function get_mode_indicator()
  local mode = vim.api.nvim_get_mode().mode
  local mode_info = mode_cache[mode] or mode_cache[mode:sub(1, 1)]
  if not mode_info then
    mode_info = { char = mode:sub(1, 1):upper(), group = 'DiagnosticHintLn' }
    mode_cache[mode] = mode_info
  end
  return hl_str(mode_info.group, ' ' .. mode_info.char .. ' ')
    .. ' '
    .. hl_str('Normal', '')
end

local function get_git_info()
  local current_time = vim.loop.now()
  if
    cache.git_root
    and cache.git_branch
    and (current_time - cache.git_check_time) < GIT_CACHE_TTL
  then
    return cache.git_root, cache.git_branch
  end
  cache.git_check_time = current_time
  local root_ok, root = pcall(function()
    local handle = io.popen 'git rev-parse --show-toplevel 2>/dev/null'
    if not handle then
      return nil
    end
    local result = handle:read('*a'):gsub('\n', '')
    handle:close()
    return #result > 0 and result or nil
  end)
  local branch_ok, branch = pcall(function()
    local handle = io.popen 'git branch --show-current 2>/dev/null'
    if not handle then
      return nil
    end
    local result = handle:read('*a'):gsub('\n', '')
    handle:close()
    return #result > 0 and result or nil
  end)
  cache.git_root = root_ok and root or nil
  cache.git_branch = branch_ok and branch or nil
  return cache.git_root, cache.git_branch
end

local function get_path_info(fname, level)
  local cache_key = fname .. ':' .. tostring(level)
  if cache.path_info[cache_key] then
    return cache.path_info[cache_key]
  end

  local path_str

  if vim.bo.buftype == 'help' then
    path_str = table.concat({
      hl_str('Directory', 'doc'),
      ' ',
      hl_str('Normal', vim.fn.fnamemodify(fname, ':t')),
    }, '')
    cache.path_info[cache_key] = path_str
    return path_str
  end

  local git_root, branch = get_git_info()

  local dir_only
  if git_root and fname:find(git_root, 1, true) == 1 then
    dir_only = vim.fn.fnamemodify(fname:sub(#git_root + 2), ':h')
  elseif fname:find(os.getenv 'HOME', 1, true) == 1 then
    dir_only =
      vim.fn.fnamemodify('~/' .. fname:sub(#os.getenv 'HOME' + 2), ':h')
  else
    dir_only = vim.fn.fnamemodify(fname, ':h')
  end

  local dir_display
  if dir_only ~= '.' and dir_only ~= '' then
    if level >= 1 then
      local path_parts = vim.split(dir_only, '/')
      if #path_parts > 1 then
        local abbreviated_parts = {}
        for i = 1, #path_parts - 1 do
          local part = path_parts[i]
          if part == '~' then
            table.insert(abbreviated_parts, '~')
          else
            table.insert(abbreviated_parts, part:sub(1, 1))
          end
        end
        table.insert(abbreviated_parts, path_parts[#path_parts])
        dir_display =
          hl_str('Directory', table.concat(abbreviated_parts, '/') .. '/')
      else
        dir_display = hl_str('Directory', path_parts[1] .. '/')
      end
    else
      dir_display = hl_str('Directory', dir_only .. '/')
    end
  end

  local parts = {}
  if branch then
    table.insert(parts, hl_str('DiagnosticError', branch))
  end

  if dir_display then
    if #parts > 0 then
      table.insert(parts, '  ')
    end
    table.insert(parts, dir_display)
  end

  if #parts > 0 then
    table.insert(parts, ' ')
  end
  table.insert(parts, hl_str('Normal', vim.fn.fnamemodify(fname, ':t')))
  path_str = table.concat(parts, '')

  cache.path_info[cache_key] = path_str
  return path_str
end

local function get_diag_str()
  if not vim.diagnostic or not vim.diagnostic.count then
    return ''
  end
  local current_time = vim.loop.now()
  local buf = vim.api.nvim_get_current_buf()
  if
    cache.diag_count[buf]
    and (current_time - cache.diag_check_time) < DIAG_CACHE_TTL
  then
    return cache.diag_count[buf]
  end
  cache.diag_check_time = current_time
  local parts = {}
  local total = vim.diagnostic.count(0)
  local err_total = total[vim.diagnostic.severity.ERROR] or 0
  local warn_total = total[vim.diagnostic.severity.WARN] or 0
  if err_total > 0 then
    table.insert(
      parts,
      hl_str('DiagnosticError', diagnostics.ERROR .. ' ' .. err_total .. ' ')
    )
  end
  if warn_total > 0 then
    table.insert(
      parts,
      hl_str('DiagnosticWarn', diagnostics.WARN .. ' ' .. warn_total .. ' ')
    )
  end
  local diag_str = table.concat(parts, ' ')
  cache.diag_count[buf] = diag_str
  return diag_str
end

local sbar_chars = { ' ', '▂', '▃', '▄', '▅', '▆', '▇', '█' }

local function get_fileinfo_widget()
  local lines = vim.api.nvim_buf_line_count(0)
  local mode = vim.api.nvim_get_mode().mode
  local is_visual = mode:match '^[vV\22]'

  if is_visual then
    local wc = vim.fn.wordcount()
    local selected_lines = math.abs(vim.fn.line 'v' - vim.fn.line '.') + 1
    local selected_words = wc.visual_words or 0
    local selected_chars = wc.visual_chars or 0
    return hl_str(
      'IncSearch',
      string.format(
        ' %d lines %d words %d chars',
        selected_lines,
        selected_words,
        selected_chars
      )
    )
  else
    local buf_num = vim.api.nvim_get_current_buf()
    local current_tick = vim.b[buf_num].changedtick

    if
      not cache.wordcount[buf_num]
      or cache.wordcount_buf_tick[buf_num] ~= current_tick
    then
      cache.wordcount[buf_num] = vim.fn.wordcount()
      cache.wordcount_buf_tick[buf_num] = current_tick
    end
    local wc = cache.wordcount[buf_num]

    return hl_str(
      'StatusLine',
      string.format(
        '%d lines %d words %d chars',
        lines,
        wc.words or 0,
        wc.chars or 0
      )
    )
  end
end

local function get_scrollbar()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local total_lines = vim.api.nvim_buf_line_count(0)
  if total_lines == 0 then
    return ''
  end
  local rel_position = current_line / total_lines
  local char_index = math.floor(rel_position * #sbar_chars) + 1
  char_index = math.max(1, math.min(char_index, #sbar_chars))
  local indicator = sbar_chars[char_index]
  local hl_group
  if rel_position < 0.33 then
    hl_group = 'Special'
  elseif rel_position < 0.66 then
    hl_group = 'WarningMsg'
  else
    hl_group = 'ErrorMsg'
  end
  local percentage = math.floor(rel_position * 100)
  return hl_str(hl_group, string.rep(indicator, 2) .. ' ' .. percentage .. '%')
end

local buf_flags_cache = {}
local buf_flags_time = {}
local BUF_FLAGS_TTL = 500

local function get_buffer_flags(buf_num)
  local current_time = vim.loop.now()
  if
    buf_flags_cache[buf_num]
    and (current_time - (buf_flags_time[buf_num] or 0)) < BUF_FLAGS_TTL
  then
    return buf_flags_cache[buf_num]
  end
  buf_flags_time[buf_num] = current_time
  local flags = {
    modifiable = vim.api.nvim_get_option_value('modifiable', { buf = buf_num }),
    modified = vim.api.nvim_get_option_value('modified', { buf = buf_num }),
    readonly = vim.api.nvim_get_option_value('readonly', { buf = buf_num }),
  }
  buf_flags_cache[buf_num] = flags
  return flags
end

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    cache.path_info = {}
    buf_flags_cache = {}
    buf_flags_time = {}
  end,
})

vim.api.nvim_create_autocmd('FocusGained', {
  pattern = '*',
  callback = function()
    cache.git_root = nil
    cache.git_branch = nil
    cache.git_check_time = 0
  end,
})

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  pattern = '*',
  callback = function()
    cache.diag_count = {}
    cache.diag_check_time = 0
  end,
})

local render = function()
  local FULL_PATH_WIDTH = 150
  local ABBREVIATED_PATH_WIDTH = 110
  local HIDE_FILEINFO_WIDTH = 120
  local HIDE_SCROLLBAR_WIDTH = 75

  local width = vim.api.nvim_win_get_width(0)

  local path_level
  if width >= FULL_PATH_WIDTH then
    path_level = 0
  elseif width >= ABBREVIATED_PATH_WIDTH then
    path_level = 1
  else
    path_level = 2
  end

  local fname = vim.api.nvim_buf_get_name(0):gsub('^oil://', '')
  if
    vim.bo.buftype == 'terminal'
    or vim.bo.buftype == 'nofile'
    or vim.bo.buftype == 'prompt'
  then
    fname = vim.bo.ft
  end

  local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)

  local show_fileinfo = width >= HIDE_FILEINFO_WIDTH
  local show_scrollbar = width >= HIDE_SCROLLBAR_WIDTH

  stl_parts['mode'] = get_mode_indicator()
  stl_parts['path'] = get_path_info(fname, path_level)

  local buf_flags = get_buffer_flags(buf_num)
  if not buf_flags.modifiable then
    stl_parts['mod'] = hl_str('WarningMsg', '[!]')
  elseif buf_flags.modified then
    stl_parts['mod'] = hl_str('ErrorMsg', '[+]')
  else
    stl_parts['mod'] = ' '
  end

  stl_parts['ro'] = buf_flags.readonly and hl_str('WarningMsg', '[RO]') or ''
  stl_parts['diag'] = get_diag_str()
  stl_parts['fileinfo'] = get_fileinfo_widget()
  stl_parts['scrollbar'] = get_scrollbar()

  local stl_order_dynamic = {
    'mode',
    'pad',
    'path',
    'mod',
    'ro',
    'sep',
    'diag',
  }

  if show_fileinfo then
    table.insert(stl_order_dynamic, 'fileinfo')
  end

  if show_scrollbar then
    table.insert(stl_order_dynamic, 'pad')
    table.insert(stl_order_dynamic, 'scrollbar')
    table.insert(stl_order_dynamic, 'pad')
  end

  return ordered_tbl_concat(stl_order_dynamic, stl_parts)
end

_G.statusline_render = render

for mode, info in pairs(mode_cache) do
  if #mode == 1 then
    for _, m in ipairs { 'o', 's', 'r', 't' } do
      if not mode_cache[m] and m:sub(1, 1) == mode then
        mode_cache[m] = info
      end
    end
  end
end

vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  callback = function()
    vim.cmd 'redrawstatus'
  end,
})

vim.api.nvim_create_autocmd('WinResized', {
  pattern = '*',
  callback = function()
    vim.cmd 'redrawstatus'
  end,
})

vim.o.statusline = '%!v:lua.statusline_render()'
