local keymap = vim.keymap

keymap.set('n', ';e', ':TroubleToggle<Return>')

keymap.set('n', '<leader>n', function()
  local trouble = require 'trouble'

  if trouble.is_open() then
    trouble.next { skip_groups = true, jump = true }
  else
    trouble.open()
  end
end)

keymap.set('n', '<leader>p', function()
  local trouble = require 'trouble'

  if trouble.is_open() then
    trouble.next { skip_groups = true, jump = true }
  else
    trouble.open()
  end
end)

keymap.set('n', '<leader>q', function()
  require('trouble').toggle 'quickfix'
end)

return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    use_diagnostic_signs = true,
  },
}
