return {
  event = 'BufReadPost',
  once = true,
  setup = function()
    require('mini.diff').setup {
      mappings = {
        apply = ';gs',
        reset = ';gu',
        goto_prev = ';gp',
        goto_next = ';gn',
      },
    }
  end,
}
