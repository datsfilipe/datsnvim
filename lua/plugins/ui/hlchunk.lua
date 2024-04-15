local config = require 'core.config'

return {
  'shellRaining/hlchunk.nvim',
  event = { 'UIEnter' },
  opts = {
    chunk = {
      enable = false,
      notify = false,
    },
    indent = {
      enable = true,
      style = {
        { fg = config.indent_color },
      },
    },
    line_num = { enable = false },
    blank = {
      enable = true,
      chars = {
        '․',
      },
      style = {
        config.indent_color,
      },
    },
  },
}
