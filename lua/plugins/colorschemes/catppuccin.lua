return {
  'catppuccin/nvim',
  lazy = false,
  priority = 1000,
  opts = {
    flavour = 'mocha',
    dim_inactive = {
      enabled = false,
      shade = 'dark',
      percentage = 0.15,
    },
    transparent_background = true,
    custom_highlights = function()
      return vim.tbl_extend('force', {
        IndentLine = { fg = require('utils').static_color },
        IndentLineCurrent = { fg = require('utils').static_color },
        NotifyINFOBorder = { fg = require('utils').static_color },
      }, {})
    end,
  },
}
