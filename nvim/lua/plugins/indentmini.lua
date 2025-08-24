vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local ok, indentmini = pcall(require, 'indentmini')
    if not ok then
      return
    end

    indentmini.setup {}
  end,
})
