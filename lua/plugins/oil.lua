return {
  'stevearc/oil.nvim',
  lazy = false,
  commit = 'ba858b662599eab8ef1cba9ab745afded99cb180',
  keys = {
    { '<leader>e', '<cmd>Oil<cr>' },
  },
  opts = {
    default_file_explorer = true,
    keymaps = {
      ['<leader>v'] = 'actions.select_split',
    },
    view_options = {
      show_hidden = true,
    },
    confirmation = {
      border = 'none',
    },
    columns = {
      'mtime',
    },
  },
}
