local M = {}

local ok, nix_colorscheme = pcall(require, "utils/_nix-colorscheme")
if ok then
  M.colorscheme = nix_colorscheme
else
  M.colorscheme = "min-theme"
end

local ok2, nixos_path = pcall(require, "utils/_nix_lazylock")
if ok2 then
  M.lockfile = nixos_path
else
  M.lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
end

M.formatter = "conform"
-- M.formatter = "null-ls"

M.linter = "nvim-lint"
-- M.linter = "null-ls"

M.indent = "hlchunk"
M.indent_color = "#343434"

return M
