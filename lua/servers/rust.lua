local utils = require 'utils'
if not utils.is_bin_available 'rust_analyzer' then
  return
end

vim.lsp.config.rust_analyzer = {
  cmd = { 'rust_analyzer' },
  filetypes = { 'rust' },
  settings = {
    ['rust-analyzer'] = {
      inlayHints = {
        enable = false,
      },
    },
  },
}

vim.lsp.enable 'rust_analyzer'
