local M = {}

function M.setup()
  require 'user.core.builtins'
  require 'user.core.options'
  require 'user.core.autocmds'
  require 'user.core.keymaps'
  require 'user.core.folding'

  local theme = require 'user.core.colorscheme'
  theme.setup()

  require('user.loader').setup {
    apply_transparency = theme.apply_transparency,
  }
end

return M
