local M = {}

M.create_pr = require('extensions.minigit.create_pr').create_pull_request
M.git_pr_setup = require('extensions.minigit.create_pr').setup

M.align_blame = function(au_data)
  if au_data.data.git_subcommand ~= 'blame' then
    return
  end

  local win_src = au_data.data.win_source
  vim.wo.wrap = false
  vim.fn.winrestview { topline = vim.fn.line('w0', win_src) }
  vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

  vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
end

return M
