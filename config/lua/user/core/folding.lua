vim.o.foldlevelstart = 99
vim.o.foldmethod = 'manual'
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
      -- foldmethod is window-local; set it for all windows displaying this buffer
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == args.buf then
          vim.api.nvim_set_option_value(
            'foldmethod',
            'expr',
            { scope = 'local', win = win }
          )
          vim.api.nvim_set_option_value(
            'foldexpr',
            'v:lua.vim.lsp.foldexpr()',
            { scope = 'local', win = win }
          )
        end
      end
    end
  end,
})
