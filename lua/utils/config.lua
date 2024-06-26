local M = {}

local ok, nix_colorscheme = pcall(require, 'utils/nix_colorscheme')
if ok then
  M.colorscheme = nix_colorscheme
else
  M.colorscheme = 'min-theme'
end

local ok2, nixos_path = pcall(require, 'utils/nix_lazylock')
if ok2 then
  M.lockfile = nixos_path
else
  M.lockfile = vim.fn.stdpath 'config' .. '/lazy-lock.json'
end

M.indent_color = '#343434'

-- diagnostics
M.sign_icons = {
  Error = 'E',
  Warn = 'W',
  Info = 'I',
  Hint = 'H',
}

return M
