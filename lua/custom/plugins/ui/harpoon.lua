return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    vim.keymap.set('n', '<leader>hm', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
      print 'harpoon: toggled'
    end)
    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
      print 'harpoon: added'
    end)
    vim.keymap.set('n', '<C-j>', function()
      harpoon:list():prev()
      print 'harpoon: prev'
    end)
    vim.keymap.set('n', '<C-k>', function()
      harpoon:list():next()
      print 'harpoon: next'
    end)

    for i = 1, 9 do
      vim.keymap.set('n', '<leader>h' .. i, function()
        harpoon:list():select(i)
        print('harpoon: selected ' .. i)
      end)
    end

    harpoon:extend {
      UI_CREATE = function(cx)
        vim.keymap.set('n', '<leader>hv', function()
          harpoon.ui:select_menu_item { vsplit = true }
          print 'harpoon: vsplit'
        end, { buffer = cx.bufnr })

        vim.keymap.set('n', '<leader>hs', function()
          harpoon.ui:select_menu_item { split = true }
          print 'harpoon: split'
        end, { buffer = cx.bufnr })
      end,
    }
  end,
}
