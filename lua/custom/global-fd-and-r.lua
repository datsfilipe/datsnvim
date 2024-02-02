local M = {}

local function escape_for_tmux(command)
  return string.gsub(command, "'", "'\\''")
end

M.execute = function()
  local input = vim.fn.input('Replace text (old_str/new_str): ')
  local old_str, new_str = input:match("([^/]+)/([^/]+)")

  local git_root = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null')
  local current_dir = git_root ~= '' and git_root or vim.fn.getcwd()

  local files_cmd = vim.fn.systemlist('fd --type f --color=never . ' .. current_dir)

  local files_arg = table.concat(files_cmd, ' ')

  local sed_cmd = string.format("sed -i 's/%s/%s/g' %s", old_str, new_str, files_arg)
  local diff_cmd = string.format("git diff --color=always --unified=0 -G'%s' -- %s", old_str, files_arg)
  local cmd = string.format("%s && %s", sed_cmd, diff_cmd)

  local escaped_cmd = escape_for_tmux(cmd)
  local tmux_cmd = string.format("tmux split-window -h bash -c '%s | less -R'", escaped_cmd)
  vim.fn.system(tmux_cmd)
end

return M
