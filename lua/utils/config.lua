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

-- lsp stuff
M.servers = {
  'lua_ls',
  'cssls',
  'html',
  'tsserver',
  'jsonls',
  'tailwindcss',
  'eslint',
  'elixirls',
  'rust_analyzer',
}

M.parsers = {
  'javascript',
  'typescript',
  'tsx',
  'html',
  'css',
  'lua',
  'markdown',
  'markdown_inline',
  'bash',
  'fish',
  'rust',
  'go',
  'dockerfile',
  'json',
  'toml',
}

-- diagnostics icons
M.signs = {
  Error = '',
  Warn = '',
  Info = '󰄛',
  Hint = '󰛨',
}

-- lsp kind icons
M.kind = {
  Text = '',
  Method = 'ƒ',
  Function = '',
  Constructor = '',
  Field = '󰫧',
  Variable = '',
  Class = '',
  Interface = '',
  Module = '',
  Property = '',
  Unit = '󰇎',
  Value = '',
  Enum = '',
  Keyword = '󰌆',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

return M
