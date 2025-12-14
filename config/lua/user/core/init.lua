local M = {}

function M.init()
  require 'user.core.builtins'
  require 'user.core.options'
  require 'user.core.autocmds'
  require 'user.core.keymaps'
  require 'user.core.folding'

  require('user.loader').setup()
end

return M
