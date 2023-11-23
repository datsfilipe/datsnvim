local M = {}

local ok, nix_colorscheme = pcall(require, "utils/_nix-colorscheme")
if ok then
  M.colorscheme = nix_colorscheme
end

M.colorscheme = "min-theme"

local ok2, nixos_path = pcall(require, "utils/_nix_lazylock")
if ok2 then
  M.lockfile = nixos_path
end

M.lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"

M.formatter = "conform"
-- M.formatter = "null-ls"

M.linter = "nvim-lint"
-- M.linter = "null-ls"

M.indent = "hlchunk"
M.indent_color = "#343434"

return M
