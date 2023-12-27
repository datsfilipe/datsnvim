return {
  'ThePrimeagen/harpoon',
  event = 'BufEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local ui = require 'harpoon.ui'
    local mark = require 'harpoon.mark'
    local keymap = vim.keymap

    keymap.set('n', '<leader>hm', function()
      ui.toggle_quick_menu()
    end)

    keymap.set('n', '<leader>ha', function()
      mark.add_file()
      print '[harpoon] mark added'
    end)

    keymap.set('n', '<leader>hd', function()
      mark.rm_file(vim.fn.expand '%')
      print '[harpoon] mark deleted'
    end)

    keymap.set('n', '<C-j>', function()
      ui.nav_prev()
    end)

    keymap.set('n', '<C-k>', function()
      ui.nav_next()
    end)
  end,
}
