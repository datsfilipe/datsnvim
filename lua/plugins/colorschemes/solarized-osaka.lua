return {
  'craftzdog/solarized-osaka.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    on_highlights = function(hl, _)
      for k, v in pairs {
        IndentLine = { fg = require('utils').static_color },
        IndentLineCurrent = { fg = require('utils').static_color },
        NotifyINFOBorder = { fg = require('utils').static_color },
      } do
        hl[k] = v
      end
    end,
  },
}
