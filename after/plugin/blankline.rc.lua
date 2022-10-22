local present, blankline = pcall(require, 'indent_blankline')
if not present then
  return
end

blankline.setup {
  space_char_blankline = ' ',
  char_highlight_list = {
    'IndentBlanklineIndent1',
  },
}
