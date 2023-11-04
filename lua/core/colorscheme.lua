local nix = false
local nix_filepath = "$HOME/.config/nvim/lua/nix-colorscheme"
if vim.fn.filereadable(nix_filepath) then
  nix = true
end

local theme = "min-theme"
if nix then
  theme = require("nix-colorscheme")
end

return theme