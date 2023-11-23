local ok, nix_colorscheme = pcall(require, "utils/_nix-colorscheme")
if ok then return nix_colorscheme end

return "min-theme"
