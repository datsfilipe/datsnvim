local static_color = require('utils').static_color

require('catppuccin').setup {
  flavour = 'mocha',
  dim_inactive = {
    enabled = false,
    shade = 'dark',
    percentage = 0.15,
  },
  transparent_background = true,
  custom_highlights = function()
    return vim.tbl_extend('force', {
      IndentLine = { fg = static_color },
      IndentLineCurrent = { fg = static_color },
      NotifyINFOBorder = { fg = static_color },
    }, {})
  end,
}
