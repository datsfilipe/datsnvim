local utils = require 'utils'
if not utils.is_bin_available 'rust-analyzer' then
  return
end

return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  settings = {
    ['rust-analyzer'] = {
      inlayHints = {
        enable = false,
      },
    },
  },
}
