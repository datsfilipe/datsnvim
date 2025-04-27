return {
  'datsfilipe/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  opts = {
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
      IndentLine = { fg = require('utils').static_color },
      IndentLineCurrent = { fg = require('utils').static_color },
      NotifyINFOBorder = { fg = require('utils').static_color },
    }, {}),
  },
}
