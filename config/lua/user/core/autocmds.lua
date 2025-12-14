vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    if vim.bo.buftype == '' then
      vim.opt.paste = false
    end
  end,
})
