local utils = require 'utils'
if not utils.is_bin_available 'gopls' then
  return
end

return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gotmpl', 'gowork' },
}
