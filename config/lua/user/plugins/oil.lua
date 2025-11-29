local M = {}

function M.setup()
  if M._loaded then
    return
  end
  M._loaded = true

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
end

return M
