local M = {}

function M.setup()
  require('user.core.builtins').setup()
  require('user.core.options').setup()
  require('user.core.autocmds').setup()
  require('user.core.keymaps').setup()
  require('user.core.folding').setup()

  local theme = require('user.core.theme')
  theme.setup()

  require('user.loader').setup {
    apply_transparency = theme.apply_transparency,
  }
end

return M
