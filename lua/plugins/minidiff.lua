return {
  'echasnovski/mini.diff',
  event = 'BufRead',
  main = 'mini.diff',
  opts = {
    mappings = {
      reset = ';gr',
      -- reset these, prefer using from minigit when possible
      apply = '',
      goto_prev = '',
      goto_next = '',
    },
  },
}
