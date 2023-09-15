local ok, zenmode = pcall(require, "zen-mode")
if not ok then
  return
end

local map = require("core.utils").map

map {
  "n",
  "<leader>z",
  function()
    zenmode.toggle()
  end,
}