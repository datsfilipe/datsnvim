vim.o.foldlevelstart = 99
vim.o.foldmethod = 'indent'
vim.wo.foldtext = ''

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if
      client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange)
    then
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})
