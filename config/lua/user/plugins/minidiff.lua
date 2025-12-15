vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    require('mini.diff').setup {
      mappings = {
        apply = ';gs',
        reset = ';gu',
        goto_prev = ';gp',
        goto_next = ';gn',
      },
    }
  end,
})
