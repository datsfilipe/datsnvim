local ok, _ = pcall(require, 'harpoon')
if not ok then
  return
end

local ui = require 'harpoon.ui'
local mark = require 'harpoon.mark'

local nmap = require('dtsf.utils').nmap
local opts = { noremap = true, silent = true }

nmap {
  '<leader>hm',
  function()
    ui.toggle_quick_menu()
  end,
  opts,
}
nmap {
  '<leader>ha',
  function()
    mark.add_file()
    print '[harpoon] mark added'
  end,
  opts,
}
nmap {
  '<leader>hd',
  function()
    mark.rm_file(vim.fn.expand '%')
    print '[harpoon] mark deleted'
  end,
  opts,
}
nmap {
  '<C-k>',
  function()
    ui.nav_prev()
  end,
  opts,
}
nmap {
  '<C-j>',
  function()
    ui.nav_next()
  end,
  opts,
}