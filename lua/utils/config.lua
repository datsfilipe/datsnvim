local M = {}

local ok, nix_colorscheme = pcall(require, "utils/_nix-colorscheme")
if ok then
  M.colorscheme = nix_colorscheme
end

M.colorscheme = "min-theme"

local ok, nixos_path = pcall(require, "utils/_nix_lazylock")
if ok then
  M.lockfile = nixos_path
end

M.lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"

return M
