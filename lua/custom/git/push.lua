local M = {}

function M.git_push_with_prompt()
  vim.ui.input(
    { prompt = 'remote (default: default branch remote): ' },
    function(remote)
      local default_remote = vim.fn
        .system('git symbolic-ref refs/remotes/origin/HEAD --short')
        :match '^%a+/(.+)'
      remote = remote or default_remote
      vim.ui.input({ prompt = 'branch (default: current): ' }, function(branch)
        if not branch then
          branch = vim.fn.system('git branch --show-current'):gsub('\n', '')
        end
        vim.cmd('silent !git push ' .. remote .. ' ' .. branch)
      end)
    end
  )
end

return M
