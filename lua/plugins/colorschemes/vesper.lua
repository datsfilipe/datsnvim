return {
  'datsfilipe/vesper.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    italics = {
      comments = false,
      keywords = false,
      functions = false,
      strings = false,
      variables = false,
    },
    overrides = vim.tbl_extend('force', {
      IndentLineChar = { fg = require('utils').static_color },
      NotifyINFOBorder = { fg = require('utils').static_color },
    }, {}),
  },
}
