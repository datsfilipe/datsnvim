local utils = require 'utils'
if not utils.is_bin_available 'vscode-json-language-server' then
  return
end

vim.lsp.config.json = {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  init_options = {
    provideFormatter = true,
  },

  commands = {
    Format = function()
      vim.lsp.buf.format { range = { { 0, 0 }, { vim.fn.line '$', 0 } } }
    end,
  },
}

vim.lsp.enable 'json'
