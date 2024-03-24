local keymap = vim.keymap

keymap.set('n', '<leader>e', ':Oil<Return>', { noremap = true, silent = true })

return {
  'stevearc/oil.nvim',
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
