vim.o.foldlevelstart = 99
vim.o.foldmethod = 'manual'
vim.wo.foldtext = ''

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if
      client
      and client:supports_method(
        vim.lsp.protocol.Methods.textDocument_foldingRange
      )
    then
      local win = vim.api.nvim_get_current_win()
      if vim.api.nvim_win_get_buf(win) == args.buf then
        vim.wo[win].foldmethod = 'expr'
        vim.wo[win].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end
    end
  end,
})
