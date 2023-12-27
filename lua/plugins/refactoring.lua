return {
  'ThePrimeagen/refactoring.nvim',
  event = 'BufRead',
  keys = {
    {
      '<leader>r',
      function()
        require('refactoring').select_refactor()
      end,
      mode = 'v',
      noremap = true,
      silent = true,
      expr = false,
    },
  },
  opts = {},
}
