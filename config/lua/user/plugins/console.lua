vim.api.nvim_create_autocmd('CmdlineEnter', {
  callback = function()
    require('console').setup {
      hijack_bang = true,
      close_key = ';q',
    }
  end,
})
