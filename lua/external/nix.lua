local M = {}

M.colorscheme = nil
M.lockfile = nil

local is_nix_colorscheme_set, nix_colorscheme =
  pcall(require, 'utils/nix_colorscheme')
if is_nix_colorscheme_set then
  M.colorscheme = nix_colorscheme
end

local is_nix_lazylock_set, nixos_path = pcall(require, 'utils/nix_lazylock')
if is_nix_lazylock_set then
  M.lockfile = nixos_path
end

return M
