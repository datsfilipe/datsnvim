local utils = require 'utils'
if not utils.is_bin_available 'vscode-css-language-server' then
  return
end

vim.lsp.config.cssls = {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  init_options = {
    provideFormatter = false,
  },
}

vim.lsp.enable 'cssls'
