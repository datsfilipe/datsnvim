local ok, gruvbox = pcall(require, 'gruvbox')
if not ok then
  return
end

gruvbox.setup {
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
    -- change telescope window highlight
    TelescopeResultsBorder = { fg = '#504945', bg = 'NONE' },
    TelescopePromptBorder = { fg = '#504945', bg = 'NONE' },
    TelescopePreviewBorder = { fg = '#504945', bg = 'NONE' },
    -- Make float windows transparent too
    NormalFloat = { bg = 'NONE' },
  },
}

vim.cmd 'colorscheme gruvbox'