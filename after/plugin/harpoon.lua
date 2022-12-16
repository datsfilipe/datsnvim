local ok, _ = pcall(require, 'harpoon')
if not ok then
  return
end

local ui = require 'harpoon.ui'
local mark = require 'harpoon.mark'

local nmap = require('dtsf.keymap').nmap
local opts = { noremap = true, silent = true }

nmap {
  '<C-h>g',
  function()
    ui.toggle_quick_menu()
    print '[harpoon] Quick Menu'
  end,
  opts,
}
nmap {
  '<C-h>h',
  function()
    mark.add_file()
    print '[harpoon] Add Mark'
  end,
  opts,
}
nmap {
  '<C-h>j',
  function()
    ui.nav_prev()
    print '[harpoon] Jump to previous mark'
  end,
  opts,
}
nmap {
  '<C-h>k',
  function()
    ui.nav_next()
    print '[harpoon] Jump to next mark'
  end,
  opts,
}
nmap {
  '<C-h>l',
  function()
    mark.rm_file(vim.fn.expand '%')
    print '[harpoon] Remove Mark'
  end,
  opts,
}
