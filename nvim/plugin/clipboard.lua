vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    if vim.v.event.regname == '+' or vim.v.event.regname == '*' then
      vim.highlight.on_yank()
    end
  end,
})

local function paste_internal()
  return { vim.fn.getreg '"', vim.fn.getregtype '"' }
end

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy '+',
    ['*'] = require('vim.ui.clipboard.osc52').copy '*',
  },
  paste = {
    ['+'] = paste_internal,
    ['*'] = paste_internal,
  },
}
