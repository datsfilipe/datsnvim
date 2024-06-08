return {
  'echasnovski/mini-git',
  version = false,
  main = 'mini.git',
  keys = {
    { '<leader>gd', '<cmd>Git diff %<cr>' },
    { '<leader>gD', '<cmd>Git diff<cr>' },
    { '<leader>gl', '<cmd>Git log<cr>' },
    { '<leader>ga', '<cmd>Git add<cr>' },
    { '<leader>gA', '<cmd>Git add %<cr>' },
    { '<leader>gc', '<cmd>Git commit<cr>' },
    { '<leader>gca', '<cmd>Git commit -a<cr>' },
    { '<leader>gs', '<cmd>Git status<cr>' },
    { '<leader>gp', '<cmd>Git push origin main<cr>' },
    { '<leader>gpu', ':Git push --set-upstream origin ' },
  },
  opts = {},
}
