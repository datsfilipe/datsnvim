local keymap = vim.keymap

keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>')
keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>')
keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>')

return {
  'nvim-pack/nvim-spectre',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}
