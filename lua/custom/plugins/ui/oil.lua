return {
  'stevearc/oil.nvim',
  lazy = false,
  keys = {
    { '<leader>e', '<cmd>Oil<cr>' },
    { '<leader>r', '<cmd>edit %:p:h<cr>' },
  },
  opts = {
    default_file_explorer = true,
    keymaps = {
      ['<leader>H'] = 'actions.select_split',
    },
    view_options = {
      show_hidden = true,
    },
    columns = {
      'mtime',
    },
  },
}
