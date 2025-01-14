return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    undercurl = true,
    transparent = true,
    overrides = function(_)
      local highlights = {}

      for k, v in pairs {
        IndentLineChar = { fg = require('utils').static_color },
        NotifyINFOBorder = { fg = require('utils').static_color },
      } do
        highlights[k] = v
      end

      highlights['Visual'] = { bg = '#363646' }

      return vim.tbl_extend('force', highlights, {})
    end,
    theme = 'dragon',
  },
}
