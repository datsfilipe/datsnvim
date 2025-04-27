local diagnostics = require('icons').diagnostics

local stl_parts = {
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

local stl_order = {
  'pad',
  'path',
  'mod',
  'ro',
  'sep',
  'diag',
  'fileinfo',
  'pad',
  'scrollbar',
  'pad',
}

local function get_git_root()
  local handle = io.popen 'git rev-parse --show-toplevel 2>/dev/null'
  if not handle then
    return nil
  end

  local root = handle:read '*a'
  handle:close()

  root = root:gsub('\n', '')
  return #root > 0 and root or nil
end

local function get_git_branch()
  local handle = io.popen 'git branch --show-current 2>/dev/null'
  if not handle then
    return nil
  end

  local branch = handle:read '*a'
  handle:close()

  branch = branch:gsub('\n', '')
  return #branch > 0 and branch or nil
end

local function ordered_tbl_concat(order_tbl, stl_part_tbl)
  local str_table = {}
  for _, val in ipairs(order_tbl) do
    local part = stl_part_tbl[val]
    if part then
      table.insert(str_table, part)
    end
  end
  return table.concat(str_table, ' ')
end

local function hl_str(hl_group, str)
  return string.format('%%#%s#%s%%', hl_group, str)
end

local function get_path_info(fname)
  local file_name = vim.fn.fnamemodify(fname, ':t')
  local path_str = ''

  if vim.bo.buftype == 'help' then
    return hl_str('Directory', '.*' .. ' ' .. file_name)
  end

  local git_root = get_git_root()
  local branch = get_git_branch()
  local dir_path = ''

  if git_root and fname:find(git_root, 1, true) == 1 then
    dir_path = fname:sub(#git_root + 2)
    dir_path = dir_path:match '(.*)/[^/]*$' or ''
    if dir_path ~= '' then
      dir_path = dir_path .. '/'
    end
  elseif fname:find(os.getenv 'HOME', 1, true) == 1 then
    dir_path = '~/' .. fname:sub(#os.getenv 'HOME' + 2)
    dir_path = dir_path:match '(.*)/[^/]*$' or ''
    if dir_path ~= '' then
      dir_path = dir_path .. '/'
    end
  else
    dir_path = vim.fn.fnamemodify(fname, ':h') .. '/'
  end

  local repo_info = ''
  if branch then
    repo_info = hl_str('DiagnosticError', branch)
      .. ' '
      .. hl_str('Normal', ':')
      .. ' '
  end

  path_str = repo_info
    .. ' '
    .. hl_str('Directory', dir_path)
    .. ' '
    .. hl_str('Normal', file_name)

  return path_str
end

local function get_diag_str()
  if not vim.diagnostic or not vim.diagnostic.count then
    return ''
  end

  local diag_str = ''
  local total = vim.diagnostic.count(0)

  local err_total = total[vim.diagnostic.severity.ERROR] or 0
  local warn_total = total[vim.diagnostic.severity.WARN] or 0

  if err_total > 0 then
    diag_str = diag_str
      .. ' '
      .. hl_str('DiagnosticError', diagnostics.ERROR .. ' ' .. err_total .. ' ')
  end

  if warn_total > 0 then
    diag_str = diag_str
      .. ' '
      .. hl_str('DiagnosticWarn', diagnostics.WARN .. ' ' .. warn_total .. ' ')
  end

  return diag_str
end

local function get_fileinfo_widget()
  local lines = vim.api.nvim_buf_line_count(0)
  local info_str = ''

  local mode = vim.api.nvim_get_mode().mode
  local is_visual = mode:match '^[vV\22]'

  if is_visual then
    local wc = vim.fn.wordcount()
    local selected_lines = math.abs(vim.fn.line 'v' - vim.fn.line '.') + 1
    local selected_words = wc.visual_words or 0
    local selected_chars = wc.visual_chars or 0

    info_str = hl_str(
      'IncSearch',
      string.format(
        ' %d lines %d words %d chars',
        selected_lines,
        selected_words,
        selected_chars
      )
    )
  else
    local wc = vim.fn.wordcount()
    local words = wc.words or 0
    local chars = wc.chars or 0

    info_str = hl_str(
      'StatusLine',
      string.format('%d lines %d words %d chars', lines, words, chars)
    )
  end

  return info_str
end

local function get_scrollbar()
  local sbar_chars = {
    '▁',
    '▂',
    '▃',
    '▄',
    '▅',
    '▆',
    '▇',
    '█',
  }

  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local total_lines = vim.api.nvim_buf_line_count(0)
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

local render = function()
  local fname = vim.api.nvim_buf_get_name(0):gsub('^oil://', '')
  if
    vim.bo.buftype == 'terminal'
    or vim.bo.buftype == 'nofile'
    or vim.bo.buftype == 'prompt'
  then
    fname = vim.bo.ft
  end

  local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)

  stl_parts['path'] = get_path_info(fname)

  if not vim.api.nvim_get_option_value('modifiable', { buf = buf_num }) then
    stl_parts['mod'] = hl_str('WarningMsg', '[!]')
  elseif vim.api.nvim_get_option_value('modified', { buf = buf_num }) then
    stl_parts['mod'] = hl_str('ErrorMsg', '[+]')
  else
    stl_parts['mod'] = ' '
  end

  stl_parts['ro'] = vim.api.nvim_get_option_value('readonly', { buf = buf_num })
      and hl_str('WarningMsg', '[RO]')
    or ''

  stl_parts['diag'] = get_diag_str()
  stl_parts['fileinfo'] = get_fileinfo_widget()
  stl_parts['scrollbar'] = get_scrollbar()

  return ordered_tbl_concat(stl_order, stl_parts)
end

_G.statusline_render = render

return {
  dir = vim.fn.stdpath 'config' .. '/lua/extras/statusline',
  name = 'statusline',
  lazy = false,
  config = function()
    vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
      pattern = { '*' },
      callback = function()
        local mode = vim.api.nvim_get_mode().mode
        if mode:match '^[vV\22]' then
          vim.cmd 'redrawstatus'
        end
      end,
    })

    vim.o.statusline = '%!v:lua.statusline_render()'
  end,
}
