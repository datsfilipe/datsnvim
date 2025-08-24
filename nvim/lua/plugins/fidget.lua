vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    local ok, fidget = pcall(require, 'fidget')
    if not ok then
      return
    end

    fidget.setup { progress = { display = { done_icon = 'OK' } } }
  end,
})
