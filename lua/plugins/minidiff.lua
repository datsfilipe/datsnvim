return {
  'echasnovski/mini.diff',
  event = 'BufRead',
  keys = {
    {
      ';go',
      function()
        require('mini.diff').toggle_overlay()
      end,
      desc = 'toggle diff overlay',
    },
  },
  opts = {
    mappings = {
      reset = ';gr',
      apply = ';ga',
      goto_prev = '',
      goto_next = '',
    },
  },
}
