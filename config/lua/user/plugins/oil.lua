return {
  keys = {
    { 'n', '<leader>e', '<cmd>Oil<cr>', 'file explorer' },
    { 'n', '<leader>t', '<cmd>Oil --trash<cr>', 'trash' },
  },
  after = 'apply_transparency',
  setup = function()
    require('oil').setup {
      delete_to_trash = false,
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ['<leader>v'] = 'actions.select_split',
        ['<C-l>'] = { 'actions.send_to_qflist', opts = { action = 'r' } },
        ['<C-c>'] = 'actions.refresh',
        [';y'] = {
          callback = function()
            local dir = require('oil').get_current_dir()
            if dir then
              vim.fn.setreg('+', dir)
              vim.notify 'path copied'
            end
          end,
          desc = 'copy path',
        },
      },
      view_options = {
        show_hidden = true,
      },
      confirmation = {
        border = 'none',
      },
      columns = {
        'permissions',
        'size',
        'mtime',
      },
    }
  end,
  ensure = true,
}
