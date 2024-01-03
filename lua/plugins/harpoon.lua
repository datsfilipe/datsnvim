return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  event = 'BufEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    local keymap = vim.keymap

    keymap.set('n', '<leader>hm', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    keymap.set('n', '<leader>ha', function()
      harpoon:list():append()
    end)

    keymap.set('n', '<C-j>', function()
      harpoon:list():prev()
    end)

    keymap.set('n', '<C-k>', function()
      harpoon:list():next()
    end)

    for i = 1, 9 do
      keymap.set('n', '<leader>h' .. i, function()
        harpoon:list():select(i)
      end)
    end

    harpoon:extend {
      UI_CREATE = function(cx)
        vim.keymap.set('n', '<leader>hv', function()
          harpoon.ui:select_menu_item { vsplit = true }
        end, { buffer = cx.bufnr })

        vim.keymap.set('n', '<leader>hs', function()
          harpoon.ui:select_menu_item { split = true }
        end, { buffer = cx.bufnr })
      end,
    }
  end,
}
