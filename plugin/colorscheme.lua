local nix = require 'external.nix'
local colorscheme = nix.colorscheme or 'vesper'

vim.cmd('colorscheme ' .. colorscheme)
