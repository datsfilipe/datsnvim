local utils = require 'utils'
if not utils.is_bin_available 'gopls' then
  return
end

vim.lsp.config.gopls = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gotmpl', 'gowork' },
}

vim.lsp.enable 'gopls'
