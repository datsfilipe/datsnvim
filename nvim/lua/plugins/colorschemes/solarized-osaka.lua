local static_color = require('utils').static_color

require('solarized-osaka.nvim').setup {
  on_highlights = function(hl, _)
    for k, v in pairs {
      IndentLine = { fg = static_color },
      IndentLineCurrent = { fg = static_color },
      NotifyINFOBorder = { fg = static_color },
    } do
      hl[k] = v
    end
  end,
}
