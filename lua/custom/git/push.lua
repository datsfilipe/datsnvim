local M = {}

function M.git_push_with_prompt()
  vim.ui.input({ prompt = 'Remote (default: origin): ' }, function(remote)
    remote = remote or 'origin'
    vim.ui.input({ prompt = 'Branch (default: current): ' }, function(branch)
      if not branch then
        branch = vim.fn.system('git branch --show-current'):gsub('\n', '')
      end
      vim.cmd('!git push ' .. remote .. ' ' .. branch)
    end)
  end)
end

return M
