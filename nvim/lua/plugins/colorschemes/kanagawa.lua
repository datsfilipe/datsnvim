local static_color = require('utils').static_color

require('kanagawa.nvim').setup {
  undercurl = true,
  transparent = true,
  overrides = function(_)
    local highlights = {}

    for k, v in pairs {
      IndentLine = { fg = static_color },
      IndentLineCurrent = { fg = static_color },
      NotifyINFOBorder = { fg = static_color },
    } do
      highlights[k] = v
    end

    highlights['Visual'] = { bg = '#363646' }

    return vim.tbl_extend('force', highlights, {})
  end,
  theme = 'dragon',
}
