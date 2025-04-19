return {
  'echasnovski/mini.diff',
  event = 'BufRead',
  main = 'mini.diff',
  opts = {
    mappings = {
      apply = ';ga',
      reset = ';gu',
      goto_prev = ';gk',
      goto_next = ';gj',
    },
  },
}
