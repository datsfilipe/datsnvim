local M = {}

local function escape_for_shell(command)
  command = string.gsub(command, "'", "'\\''")
  command = string.gsub(command, '"', '\\"')
  command = string.gsub(command, '%$', '\\$')
  command = string.gsub(command, '%(', '\\(')
  command = string.gsub(command, '%)', '\\)')
  return command
end

M.execute = function()
  local input = vim.fn.input 'ast-grep: '
  if input == nil or input == '' then
    print 'No input provided.'
    return
  end

  local cmd = 'ast-grep ' .. input
  local escaped_cmd = escape_for_shell(cmd)
  local split_cmd =
    string.format("vsplit | terminal fish -c '%s; cat'", escaped_cmd)
  vim.cmd(split_cmd)
end

return M
