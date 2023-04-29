local ok, null_ls = pcall(require, 'null-ls')
if not ok then
  return
end

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    filter = function(client)
      return client.name == 'null-ls'
    end,
    bufnr = bufnr,
  }
end

local sources = {
  -- diagnostics
  null_ls.builtins.diagnostics.eslint_d.with {
    diagnostics_format = '[#{c}] #{m} (#{s})',
  },
  null_ls.builtins.diagnostics.fish,
  null_ls.builtins.diagnostics.cspell.with {
    filetypes = { 'markdown', 'text' },
  },
  -- formatting
  null_ls.builtins.formatting.eslint_d,
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.rustywind,
  -- code actions
  null_ls.builtins.code_actions.gitsigns,
  -- editorconfig
  null_ls.builtins.diagnostics.editorconfig_checker,
}

local on_attach = function(client, bufnr)
  if client.supports_method 'textDocument/formatting' then
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
      end,
    })
  end
end

null_ls.setup {
  on_attach = on_attach,
  sources = sources,
}

vim.api.nvim_create_user_command('DisableLspFormatting', function()
  vim.api.nvim_clear_autocmds { group = augroup, buffer = 0 }
end, { nargs = 0 })
