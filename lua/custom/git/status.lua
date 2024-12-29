local M = {}

function M.git_status_quickfix()
  local status_output = vim.fn.system 'git status --porcelain'
  local qf_list = {}
  for file in status_output:gmatch '[^\r\n]+' do
    local status = file:sub(1, 2)
    local filename = file:sub(4)
    table.insert(qf_list, { filename = filename, text = status })
  end
  vim.fn.setqflist(qf_list)
  vim.cmd 'copen'
end

return M
