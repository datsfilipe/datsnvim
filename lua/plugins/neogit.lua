return {
  'NeogitOrg/neogit',
  cmd = 'Neogit',
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'neogit' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'echasnovski/mini.pick',
  },
}
