local blame_functions = require 'custom.git.blame'

vim.api.nvim_create_user_command(
  'CustomGitBlame',
  blame_functions.create_blame_popup,
  {}
)
