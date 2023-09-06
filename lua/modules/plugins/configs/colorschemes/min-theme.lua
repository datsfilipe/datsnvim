local ok, min = pcall(require, 'min-theme')
if not ok then
  return
end

min.setup {
  theme = 'dark',
  transparent = true,
  italics = {
    comments = false,
    keywords = false,
    functions = false,
    strings = false,
    variables = false,
  },
  overrides = {
    IndentBlanklineIndent1 = { fg = '#282828', bg = 'NONE' },
  },
}

vim.cmd [[colorscheme min-theme]]