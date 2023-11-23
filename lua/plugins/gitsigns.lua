local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
  return
end

local set_maps = require "core.keymaps.integrations.gitsigns"

gitsigns.setup {
  on_attach = set_maps(gitsigns),
}
