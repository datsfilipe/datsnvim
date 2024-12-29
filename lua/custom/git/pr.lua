local M = {}

local utils_functions = require 'custom.git.utils'

M.create = function()
  local template_path = (
    utils_functions.return_project_root()
    .. '/.github/pull_request_template.md'
  ):match '^%a+://(.*)$'
  print(vim.fn.filereadable(template_path), template_path)

  local base_branch = utils_functions.get_base_branch()
  local current_branch = utils_functions.get_current_branch()
  local branch_status = utils_functions.get_branch_info()

  if current_branch == base_branch:match '/(.+)' then
    vim.notify(
      'cannot create PR from the default branch: ' .. base_branch,
      vim.log.levels.ERROR
    )
    return
  end

  local commits =
    vim.fn.systemlist('git log --oneline ' .. base_branch .. '..HEAD')

  if #commits == 0 then
    vim.notify('No changes to be added to the PR', vim.log.levels.ERROR)
    return
  end

  local pr_message = ''
  if vim.fn.filereadable(template_path) == 1 then
    vim.cmd('tabe ' .. vim.fn.tempname())

    local template_lines = vim.fn.readfile(template_path)
    vim.fn.setline(1, template_lines)
    vim.cmd 'setlocal filetype=markdown'
  else
    vim.cmd('tabe ' .. vim.fn.tempname())

    pr_message = table.concat({
      '',
      '# Please enter the PR message for your changes. Lines starting',
      "# with '#' will be ignored, and an empty message aborts the PR.",
      '#',
      '# On branch ' .. branch_status .. '...' .. base_branch,
      '#',
      '# Changes to be included in this PR:',
    }, '\n')

    for _, commit in ipairs(commits) do
      pr_message = pr_message .. '\n#    ' .. commit
    end

    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(pr_message, '\n'))
    vim.bo[buf].filetype = 'gitcommit'
  end

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = vim.api.nvim_get_current_buf(),
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
          'invalid PR message, please provide a title.',
          vim.log.levels.ERROR
        )
        return
      end

      pr_message = string.format('%s\n\n%s', title, description)

      local command = string.format(
        'gh pr -a @me create --base %s --title "%s" --body "%s"',
        base_branch,
        title,
        pr_message
      )
      vim.fn.systemlist(command)

      if vim.v.shell_error == 0 then
        vim.notify('PR created successfully', vim.log.levels.INFO)
      else
        vim.notify('failed to create PR', vim.log.levels.ERROR)
      end
    end,
  })

  vim.notify(
    'edit the message and save the file to create a PR',
    vim.log.levels.INFO
  )
end

return M
