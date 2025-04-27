local utils = require 'utils'
if not utils.is_bin_available 'vscode-css-language-server' then
  return
end

return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  init_options = {
    provideFormatter = false,
  },
}
