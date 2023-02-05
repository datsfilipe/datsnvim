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

vim.api.nvim_set_hl(0, 'IndentBlanklineIndent1', { fg = '#262626' })
