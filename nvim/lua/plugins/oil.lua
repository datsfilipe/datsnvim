local ok, oil = pcall(require, 'oil')
if not ok then
  return
end

oil.setup {
  default_file_explorer = true,
  keymaps = {
    ['<leader>v'] = 'actions.select_split',
    ['<C-l>'] = { 'actions.send_to_qflist', opts = { action = 'r' } },
  },
  view_options = {
    show_hidden = true,
  },
  confirmation = {
    border = 'none',
  },
  columns = {
    'mtime',
  },
}

vim.keymap.set('n', '<leader>e', '<cmd>Oil<cr>')
