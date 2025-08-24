vim.api.nvim_create_autocmd('BufRead', {
  once = true,
  callback = function()
    local ok, diff = pcall(require, 'mini.diff')
    if not ok then
      return
    end

    diff.setup {
      mappings = {
        reset = ';gr',
        apply = ';ga',
        goto_prev = '',
        goto_next = '',
      },
    }
  end,
})
