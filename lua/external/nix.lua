local M = {}

M.colorscheme = nil

local is_nix_colorscheme_set, nix_colorscheme =
  pcall(require, 'utils/nix_colorscheme')
if is_nix_colorscheme_set then
  M.colorscheme = nix_colorscheme
end

local is_nix_lazylock_set, nixos_path = pcall(require, 'utils/nix_lazylock')
if is_nix_lazylock_set then
  M.lockfile = nixos_path
else
  M.lockfile = vim.fn.stdpath 'config' .. '/lazy-lock.json'
end

return M
