local M = {}

local function escape_for_tmux(command)
  return string.gsub(command, '\'', "'\\''")
end

M.execute = function()
  local cmd = 'ast-grep ' .. vim.fn.input 'cmd: '
  local escaped_cmd = escape_for_tmux(cmd)
  local tmux_cmd = string.format('tmux split-window -h bash -c \'%s; cat\'', escaped_cmd)
  vim.fn.system(tmux_cmd)
end

return M
