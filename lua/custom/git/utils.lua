local M = {}

function M.create_git_buffer(output, filetype)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.cmd('tabnew | b ' .. buf)
  vim.cmd('e ' .. vim.fn.tempname())
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))
  vim.bo[buf].filetype = filetype or 'git'
  vim.bo[buf].modifiable = true
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].buftype = ''
  return buf
end

function M.return_project_root()
  local path = vim.fn.expand '%:p:h'
  local git_path = vim.fn.finddir('.git', path .. ';')
  if git_path == '' then
    return nil
  else
    return vim.fn.fnamemodify(git_path, ':h')
  end
end

function M.get_base_branch()
  local branch =
    vim.fn.system 'git symbolic-ref refs/remotes/origin/HEAD --short'
  return vim.fn.trim(branch)
end

function M.get_current_branch()
  local branch = vim.fn.system 'git rev-parse --abbrev-ref HEAD'
  return vim.fn.trim(branch)
end

function M.get_git_status()
  return vim.fn.systemlist 'git status --porcelain -b'
end

function M.get_staged_files()
  return vim.fn.systemlist 'git diff --cached --name-only'
end

function M.get_unstaged_files()
  return vim.fn.systemlist 'git diff --name-only'
end

function M.get_untracked_files()
  return vim.fn.systemlist 'git ls-files --others --exclude-standard'
end

function M.get_branch_info()
  local branch_info = vim.fn.systemlist('git status -b --porcelain')[1] or ''
  return branch_info:match '^## (.+)'
end

return M
