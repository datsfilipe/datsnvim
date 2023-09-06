local present, gitsigns = pcall(require, 'gitsigns')
if not present then
  return
end

local maps = require('keymap.plugins.gitsigns')

gitsigns.setup {
  on_attach = maps(gitsigns)
}