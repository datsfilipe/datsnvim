local ok, zenmode = pcall(require, 'zen-mode')
if not ok then
  return
end

zenmode.setup {}

local nmap = require('dtsf.utils').nmap

nmap {
  '<leader>z',
  function()
    zenmode.toggle()
  end,
}
