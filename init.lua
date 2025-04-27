vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'plugins'

local lsp_configs = {}
for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)
