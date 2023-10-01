local ok, _ = pcall(require, "harpoon")
if not ok then
  return
end

local map = require("scripts.map")
local opts = { noremap = true, silent = true }

local ui = require "harpoon.ui"
local mark = require "harpoon.mark"

map {
  "n",
  "<leader>hm",
  function()
    ui.toggle_quick_menu()
  end,
  opts,
}
map {
  "n",
  "<leader>ha",
  function()
    mark.add_file()
    print "[harpoon] mark added"
  end,
  opts,
}
map {
  "n",
  "<leader>hd",
  function()
    mark.rm_file(vim.fn.expand "%")
    print "[harpoon] mark deleted"
  end,
  opts,
}
map {
  "n",
  "<C-k>",
  function()
    ui.nav_prev()
  end,
  opts,
}
map {
  "n",
  "<C-j>",
  function()
    ui.nav_next()
  end,
  opts,
}