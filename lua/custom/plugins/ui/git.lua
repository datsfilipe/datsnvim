return {
  'echasnovski/mini-git',
  version = false,
  main = 'mini.git',
  keys = {
    { '<leader>gA', '<cmd>Git add %<cr>' },
    { '<leader>gc', '<cmd>Git commit<cr>' },
    { '<leader>gC', '<cmd>Git commit -a<cr>' },
    { '<leader>gd', '<cmd>vert Git diff %<cr>' },
    { '<leader>gD', '<cmd>vert Git diff<cr>' },
    { '<leader>gl', '<cmd>vert Git log<cr>' },
    { '<leader>gs', '<cmd>Telescope git_status<cr>' },
    { '<leader>gp', '<cmd>Git push origin main<cr>' },
    { '<leader>gP', ':Git push origin ' },
    { '<leader>gg', ':Git ' },
  },
  opts = {},
}
