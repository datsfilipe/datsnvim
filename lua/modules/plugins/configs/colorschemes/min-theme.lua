local ok, min = pcall(require, "min-theme")
if not ok then
  return
end

local theme = require("core/colorscheme")
if theme == "min-theme" then
  min.setup {
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
      IndentBlanklineIndent1 = { fg = "#282828", bg = "NONE" },
      NormalFloat = { bg = "NONE" },
    },
  }

  vim.cmd [[colorscheme min-theme]]

  vim.cmd [[highlight CmpBorder guifg=#282828]]
  vim.cmd [[highlight CmpDocBorder guifg=#282828]]
end