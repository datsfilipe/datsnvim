return {
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter',
  opts = {
    on_attach = function()
      local keymap = vim.keymap

      keymap.set('n', '<leader>gs', ':Gitsigns stage_hunk<CR>')
      keymap.set('n', '<leader>gr', ':Gitsigns reset_hunk<CR>')
      keymap.set('v', '<leader>gs', ':Gitsigns stage_hunk<CR>')
      keymap.set('v', '<leader>gr', ':Gitsigns reset_hunk<CR>')
      keymap.set('n', '<leader>gu', require('gitsigns').undo_stage_hunk)
      keymap.set('n', '<leader>gb', function()
        require('gitsigns').blame_line { full = true }
      end)
    end,
  },
}
