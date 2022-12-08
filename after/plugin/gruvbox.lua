local ok, gruvbox = pcall(require, 'gruvbox')
if not ok then
  return
end

local colors = require 'gruvbox.palette'

gruvbox.setup {
  undercurl = true,
  underline = true,
  bold = true,
  italic = false,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = 'hard', -- can be 'hard', 'soft' or empty string
  overrides = {
    Normal = {
      bg = 'NONE',
    },
    NormalFloat = {
      bg = 'NONE',
    },
    SignColumn = {
      bg = 'NONE',
    },
    -- remove bg from SignColumn with git signs
    GruvboxRedSign = { fg = colors.red, bg = 'NONE', reverse = false },
    GruvboxGreenSign = { fg = colors.green, bg = 'NONE', reverse = false },
    GruvboxYellowSign = { fg = colors.yellow, bg = 'NONE', reverse = false },
    GruvboxBlueSign = { fg = colors.blue, bg = 'NONE', reverse = false },
    GruvboxPurpleSign = { fg = colors.purple, bg = 'NONE', reverse = false },
    GruvboxAquaSign = { fg = colors.aqua, bg = 'NONE', reverse = false },
    GruvboxOrangeSign = { fg = colors.orange, bg = 'NONE', reverse = false },
    -- change cmp window highlights
    Pmenu = { bg = 'NONE' },
    CmpBorder = { fg = '#504945', bg = 'NONE' },
    CmpDocBorder = { fg = '#504945', bg = 'NONE' },
    -- change indent blankline highlight
    IndentBlanklineIndent1 = { fg = '#504945' },
    -- change telescope window highlight
    TelescopeResultsBorder = { fg = '#504945', bg = 'NONE' },
    TelescopePromptBorder = { fg = '#504945', bg = 'NONE' },
    TelescopePreviewBorder = { fg = '#504945', bg = 'NONE' },
  },
  dim_inactive = false,
  transparent_mode = true,
}

vim.cmd [[ colorscheme gruvbox ]]
