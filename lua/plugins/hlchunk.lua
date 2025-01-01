return {
  'shellRaining/hlchunk.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    chunk = {
      enable = false,
      notify = false,
    },
    indent = {
      enable = true,
      style = {
        -- { fg = require('utils.config').indent_color },
      },
    },
    line_num = { enable = false },
    blank = {
      enable = true,
      chars = {
        '․',
      },
      style = {
        -- require('utils.config').indent_color,
      },
    },
  },
}
