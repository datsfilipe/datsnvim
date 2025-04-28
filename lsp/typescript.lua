local utils = require 'utils'
if not utils.is_bin_available 'typescript-language-server' then
  return
end

return {
  cmd = { 'typescript-language-server', '--stdio' },
  settings = {
    typescript = {
      server_capabilities = {
        documentFormattingProvider = false,
      },
    },
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  init_options = {
    hostInfo = 'neovim',
  },
  on_attach = function(client)
    local source_actions = vim.tbl_filter(function(action)
      return vim.startswith(action, 'source.')
    end, client.server_capabilities.codeActionProvider.codeActionKinds)

    vim.keymap.set('n', 'gsa', function()
      vim.lsp.buf.code_action {
        ---@diagnostic disable-next-line: missing-fields
        context = {
          only = source_actions,
        },
      }
    end, { desc = 'source actions' })
  end,
}
