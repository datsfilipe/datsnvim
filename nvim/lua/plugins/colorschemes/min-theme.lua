local static_color = require('utils').static_color

require('min-theme').setup {
  theme = 'dark',
  transparent = true,
  italics = {
    comments = false,
    keywords = false,
    functions = false,
    strings = false,
    variables = false,
  },
  overrides = vim.tbl_extend('force', {
    IndentLine = { fg = static_color },
    IndentLineCurrent = { fg = static_color },
    NotifyINFOBorder = { fg = static_color },
  }, {}),
}
