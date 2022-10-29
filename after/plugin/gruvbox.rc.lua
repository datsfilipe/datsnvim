local present, gruvbox = pcall(require, 'gruvbox')
if not present then
  return
end

local colors = require('gruvbox.palette')

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
  contrast = 'hard', -- can be 'hard', 'soft' or empty string
  overrides = {
    Normal = {
      bg = 'NONE'
      -- bg = '#282828'
    },
    SignColumn = {
      bg = 'NONE'
    },
    -- remove bg from SignColumn with git signs
    GruvboxRedSign = { fg = colors.red, bg = 'NONE', reverse = false },
    GruvboxGreenSign = { fg = colors.green, bg = 'NONE', reverse = false },
    GruvboxYellowSign = { fg = colors.yellow, bg = 'NONE', reverse = false },
    GruvboxBlueSign = { fg = colors.blue, bg = 'NONE', reverse = false },
    GruvboxPurpleSign = { fg = colors.purple, bg = 'NONE', reverse = false },
    GruvboxAquaSign = { fg = colors.aqua, bg = 'NONE', reverse = false },
    GruvboxOrangeSign = { fg = colors.orange, bg = 'NONE', reverse = false },
  },
  dim_inactive = false,
  transparent_mode = true,
})

vim.cmd('colorscheme gruvbox')
-- change highlight color for indent blankline
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#383838 gui=nocombine]]
-- change highlight colors for telescope
vim.cmd [[highlight TelescopePromptBorder guifg=#656565 guibg=NONE]]
vim.cmd [[highlight TelescopePreviewBorder guifg=#656565 guibg=NONE]]
vim.cmd [[highlight TelescopeResultsBorder guifg=#656565 guibg=NONE]]
-- change cmp border color
vim.cmd [[highlight CmpPmenuBorder guifg=#656565]]
vim.cmd [[highlight CmpDocPmenuBorder guifg=#656565]]
-- change highlight for float window background
vim.cmd [[highlight NormalFloat guibg=NONE]]
