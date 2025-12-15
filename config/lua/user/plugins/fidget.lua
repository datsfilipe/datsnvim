vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    require('fidget').setup { progress = { display = { done_icon = 'OK' } } }
  end,
})
