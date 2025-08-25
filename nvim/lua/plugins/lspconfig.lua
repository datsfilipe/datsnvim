local utils = require 'utils'

local servers = {
  { name = 'lua_ls', bin = 'lua-language-server' },
  {
    name = 'ts_ls',
    bin = 'typescript-language-server',
    config = {
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
      },
    },
  },
  {
    name = 'eslint',
    bin = 'vscode-eslint-language-server',
    config = { lint = true },
  },
  {
    name = 'cssls',
    bin = 'vscode-css-language-server',
    config = { init_options = { provideFormatter = false } },
  },
  {
    name = 'biome',
    bin = 'biome',
    cmd = { 'biome', 'lsp-proxy' },
  },
  {
    name = 'bashls',
    bin = 'bash-language-server',
    config = { init_options = { enableBashDebug = true } },
  },
  {
    name = 'jsonls',
    bin = 'vscode-json-language-server',
    config = { init_options = { provideFormatter = true } },
  },
  {
    name = 'solidity_ls',
    bin = 'vscode-solidity-server',
  },
  {
    name = 'rust_analyzer',
    bin = 'rust-analyzer',
    config = { ['rust-analyzer'] = { inlayHints = { enable = false } } },
  },
  {
    name = 'gopls',
    bin = 'gopls',
    config = { filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' } },
  },
}

local ok, lspconfig = pcall(require, 'lspconfig')
if not ok or not lspconfig then
  return
end

local to_enable = {}
for _, srv in ipairs(servers) do
  if utils.is_bin_available(srv.bin) then
    local cfg = vim.tbl_deep_extend('force', {}, srv.config or {})

    if srv.cmd then
      cfg.cmd = srv.cmd
    elseif not cfg.cmd and srv.bin:match '^vscode%-' then
      cfg.cmd = { srv.bin, '--stdio' }
    end

    local existing = vim.lsp.config[srv.name] or {}
    cfg = vim.tbl_deep_extend('force', existing, cfg)
    vim.lsp.config[srv.name] = cfg
    table.insert(to_enable, srv.name)
  end
end

if #to_enable > 0 then
  vim.lsp.enable(to_enable)
end
