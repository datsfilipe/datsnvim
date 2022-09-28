local present, gruvbox = pcall(require, 'gruvbox')
if not present then
  return
end

local colors = require("gruvbox.palette")

gruvbox.setup({
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
  contrast = "hard", -- can be "hard", "soft" or empty string
  overrides = {
    Normal = {
      bg = "NONE"
      --bg = "#282828"
    },
    SignColumn = {
      bg = "NONE"
    },
    -- remove bg from SignColumn with git signs
    GruvboxRedSign = { fg = colors.red, bg = "NONE", reverse = false },
    GruvboxGreenSign = { fg = colors.green, bg = "NONE", reverse = false },
    GruvboxYellowSign = { fg = colors.yellow, bg = "NONE", reverse = false },
    GruvboxBlueSign = { fg = colors.blue, bg = "NONE", reverse = false },
    GruvboxPurpleSign = { fg = colors.purple, bg = "NONE", reverse = false },
    GruvboxAquaSign = { fg = colors.aqua, bg = "NONE", reverse = false },
    GruvboxOrangeSign = { fg = colors.orange, bg = "NONE", reverse = false },
  },
  dim_inactive = false,
  transparent_mode = true,
})

vim.cmd("colorscheme gruvbox")
