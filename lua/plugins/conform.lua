local config = require('utils.config')

return {
  'stevearc/conform.nvim',
  event = 'BufEnter',
  enabled = config.formatter == 'conform',
  config = function()
    local conform = require 'conform'

    require('conform.formatters.stylua').require_cwd = true

    conform.setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        go = { 'goimports', 'gofumpt' },
      },
    }

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*',
      callback = function(args)
        conform.format { bufnr = args.buf, lsp_fallback = true }
      end,
    })
  end,
}
