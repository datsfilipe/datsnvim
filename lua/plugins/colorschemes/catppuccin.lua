local ok, catppuccin = pcall(require, 'catppuccin')
if not ok then
  return
end

catppuccin.setup {
  flavour = 'mocha',
  dim_inactive = {
    enabled = false,
    shade = 'dark',
    percentage = 0.15,
  },
  transparent_background = true,
  custom_highlights = function(colors)
    return {
      -- change telescope window highlight
      TelescopeResultsBorder = { fg = colors.surface2, bg = 'NONE' },
      TelescopePromptBorder = { fg = colors.surface2, bg = 'NONE' },
      TelescopePreviewBorder = { fg = colors.surface2, bg = 'NONE' },
      -- Blankline
      IndentBlanklineIndent1 = { fg = colors.surface2, bg = 'NONE' },
      -- Make float windows transparent too
      NormalFloat = { bg = 'NONE' },
    }
  end,
}

vim.cmd 'colorscheme catppuccin'