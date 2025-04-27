local utils = require 'utils'
if not utils.is_bin_available 'vscode-solidity-server' then
  return
end

vim.lsp.config.solidity = {
  cmd = { 'vscode-solidity-server', '--stdio' },
  filetypes = { 'solidity' },
}

vim.lsp.enable 'solidity'
