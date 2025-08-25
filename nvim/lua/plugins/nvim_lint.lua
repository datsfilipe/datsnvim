local utils = require 'utils'

local ok, lint = pcall(require, 'lint')
if not ok then
  return
end

vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function()
    if utils.is_bin_available 'codespell' then
      lint.try_lint 'codespell'
    end
  end,
})
