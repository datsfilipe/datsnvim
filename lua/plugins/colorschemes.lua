local config = require "utils/config"

return {
  {
    "datsfilipe/min-theme.nvim",
    lazy = false,
    priority = 1000,
    enabled = config.colorscheme == "min-theme",
    opts = {
      theme = "dark",
      transparent = true,
      italics = {
        comments = false,
        keywords = false,
        functions = false,
        strings = false,
        variables = false,
      },
      overrides = {
        NormalFloat = { bg = "NONE" },
        CmpBorder = { fg = config.indent_color, bg = "NONE" },
        CmpDocBorder = { fg = config.indent_color, bg = "NONE" },
        IndentLineChar = { fg = config.indent_color, bg = "NONE" },
      },
    },
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    enabled = config.colorscheme == "gruvbox",
    opts = {
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        operators = false,
        comments = false,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = 'hard',
      palette_overrides = {},
      dim_inactive = false,
      transparent_mode = true,
      overrides = {
        IndentLineChar = { fg = config.indent_color, bg = "NONE" },
        -- change telescope window highlight
        TelescopeResultsBorder = { fg = config.indent_color, bg = 'NONE' },
        TelescopePromptBorder = { fg = config.indent_color, bg = 'NONE' },
        TelescopePreviewBorder = { fg = config.indent_color, bg = 'NONE' },
        -- Make float windows transparent too
        NormalFloat = { bg = 'NONE' },
      },
    },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    enabled = config.colorscheme == "catppuccin",
    opts = {
      flavour = 'mocha',
      dim_inactive = {
        enabled = false,
        shade = 'dark',
        percentage = 0.15,
      },
      transparent_background = true,
      custom_highlights = function(colors)
        return {
          IndentLineChar = { fg = config.indent_color, bg = "NONE" },
          -- change telescope window highlight
          TelescopeResultsBorder = { fg = colors.surface2, bg = 'NONE' },
          TelescopePromptBorder = { fg = colors.surface2, bg = 'NONE' },
          TelescopePreviewBorder = { fg = colors.surface2, bg = 'NONE' },
          -- Make float windows transparent too
          NormalFloat = { bg = 'NONE' },
        }
      end,
    },
  },
}