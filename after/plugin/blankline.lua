local ok, blankline = pcall(require, 'indent_blankline')
if not ok then
  return
end

blankline.setup {
  space_char_blankline = ' ',
  char_highlight_list = {
    'IndentBlanklineIndent1',
  },
}
