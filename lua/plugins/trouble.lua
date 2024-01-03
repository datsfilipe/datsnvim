local keymap = vim.keymap

keymap.set('n', ';e', ':TroubleToggle<Return>')

keymap.set('n', '<leader>n', function()
  require('trouble').open()
  require('trouble').next { skip_groups = true, jump = true }
end)

keymap.set('n', '<leader>p', function()
  require('trouble').open()
  require('trouble').previous { skip_groups = true, jump = true }
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
