local utils = require 'utils'
if not utils.is_bin_available 'vscode-solidity-server' then
  return
end

return {
  cmd = { 'vscode-solidity-server', '--stdio' },
  filetypes = { 'solidity' },
}
