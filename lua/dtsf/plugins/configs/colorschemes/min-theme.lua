local theme = require 'min-theme'

theme.setup {
  theme = 'dark',
  transparent = true,
  italics = {
    comments = false,
    keywords = false,
    functions = false,
    strings = false,
    variables = false,
  },
  overrides = {
    IndentBlanklineIndent1 = { fg = '#282828', bg = 'NONE' },
  },
}

vim.cmd [[colorscheme min-theme]]