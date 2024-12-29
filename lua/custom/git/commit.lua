local M = {}

local utils_functions = require 'custom.git.utils'

function M.commit()
  local git_root = vim.cmd
  utils_functions.return_project_root()
  if not git_root then
    vim.notify('Not a valid Git repository', vim.log.levels.ERROR)
    return
  end

  local git_status = utils_functions.get_git_status()
  if not git_status or #git_status == 0 then
    vim.notify(
      'No changes to commit or not a valid Git repository',
      vim.log.levels.ERROR
    )
    return
  end

  local branch_status = utils_functions.get_branch_info()

  local commit_message = table.concat({
    '',
    '# Please enter the commit message for your changes. Lines starting',
    "# with '#' will be ignored, and an empty message aborts the commit.",
    '#',
    '# On branch ' .. (branch_status or 'unknown'),
    '#',
    '# Changes to be committed:',
  }, '\n')

  local staged_files = utils_functions.get_staged_files()
  for _, file in ipairs(staged_files) do
    commit_message = commit_message .. '\n#\t' .. file
  end

  commit_message = commit_message .. '\n#\n# Changes not staged for commit:'
  local unstaged_files = utils_functions.get_unstaged_files()
  for _, file in ipairs(unstaged_files) do
    commit_message = commit_message .. '\n#\t' .. file
  end

  commit_message = commit_message .. '\n#\n# Untracked files:'
  local untracked_files = utils_functions.get_untracked_files()
  for _, file in ipairs(untracked_files) do
    commit_message = commit_message .. '\n#\t' .. file
  end

  local buf = utils_functions.create_git_buffer(commit_message, 'gitcommit')

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = buf,
    callback = function()
      local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      local title, description = '', ''
      local is_description = false

      for _, line in ipairs(content) do
        if vim.fn.match(line, '^#') == -1 and line ~= '' then
          if not is_description then
            title = line
            is_description = true
          else
            description = description .. line .. '\n'
          end
        end
      end

      if title == '' then
        vim.notify(
          'Invalid commit message, please provide a title.',
          vim.log.levels.ERROR
        )
        return
      end

      commit_message = string.format('%s\n\n%s', title, description)
      local command = string.format('git commit --message="%s"', commit_message)
      vim.fn.systemlist(command)

      if vim.v.shell_error == 0 then
        vim.notify('commit completed successfully', vim.log.levels.INFO)
      else
        vim.notify('failed to create commit', vim.log.levels.ERROR)
      end
    end,
  })

  vim.notify(
    'Edit the commit message, save, and close the file to complete the commit.',
    vim.log.levels.INFO
  )
end

return M
