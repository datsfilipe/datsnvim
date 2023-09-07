local ok, zenmode = pcall(require, "zen-mode")
if not ok then
  return
end

local map = require("keymap.helper").map

map {
  "n",
  "<leader>z",
  function()
    zenmode.toggle()
  end,
}