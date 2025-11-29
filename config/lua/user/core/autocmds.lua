local M = {}

function M.setup()
  vim.api.nvim_create_autocmd('InsertLeave', {
    pattern = '*',
    command = 'set nopaste',
  })
end

return M
