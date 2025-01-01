return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    vim.keymap.set('n', '<leader>h', function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), { border = 'none' })
    end, { desc = 'harpoon: toggle quick menu' })
    vim.keymap.set('n', ';h', function()
      harpoon:list():add()
      print 'harpoon: added'
    end, { desc = 'harpoon: add' })
    vim.keymap.set('n', '<C-j>', function()
      harpoon:list():prev()
      print 'harpoon: prev'
    end, { desc = 'harpoon: prev' })
    vim.keymap.set('n', '<C-k>', function()
      harpoon:list():next()
      print 'harpoon: next'
    end, { desc = 'harpoon: next' })

    for i = 1, 9 do
      vim.keymap.set('n', '<C-h>' .. i, function()
        harpoon:list():select(i)
        print('harpoon: selected ' .. i)
      end, { desc = 'harpoon: select ' .. i })
    end

    harpoon:extend {
      UI_CREATE = function(cx)
        vim.keymap.set('n', ';hv', function()
          harpoon.ui:select_menu_item { vsplit = true }
          print 'harpoon: v'
        end, { buffer = cx.bufnr, desc = 'harpoon: vsplit' })

        vim.keymap.set('n', ';hs', function()
          harpoon.ui:select_menu_item { split = true }
          print 'harpoon: h'
        end, { buffer = cx.bufnr, desc = 'harpoon: split' })
      end,
    }
  end,
}
