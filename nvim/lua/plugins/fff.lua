local ok, fff = pcall(require, 'fff')
if not ok then
  return
end

fff.setup {
  keymaps = {
    close = '<C-c>',
  },
  hl = {
    border = 'FffBorder',
  },
}

vim.api.nvim_set_hl(0, 'FffBorder', { fg = '#000000', bg = '#000000' })

vim.keymap.set('n', ';f', function()
  fff.find_files()
end, { desc = 'Find files' })
