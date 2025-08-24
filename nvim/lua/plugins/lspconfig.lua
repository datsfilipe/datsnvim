local utils = require 'utils'

local servers = {
  { name = 'lua', bin = 'lua-language-server' },
  {
    name = 'ts',
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
    name = 'css',
    bin = 'vscode-css-language-server',
    config = { init_options = { provideFormatter = false } },
  },
  {
    name = 'biome',
    bin = 'biome',
  },
  {
    name = 'bash',
    bin = 'bash-language-server',
    config = { init_options = { enableBashDebug = true } },
  },
  {
    name = 'jsonls',
    bin = 'vscode-json-language-server',
    config = { init_options = { provideFormatter = true } },
  },
  {
    name = 'solidity',
    bin = 'vscode-solidity-server',
  },
  {
    name = 'rust',
    bin = 'rust-analyzer',
    config = { ['rust-analyzer'] = { inlayHints = { enable = false } } },
  },
  {
    name = 'go',
    bin = 'gopls',
    config = { filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' } },
  },
}

for _, srv in ipairs(servers) do
  if not utils.is_bin_available(srv.bin) then
    return
  else
    if srv.config then
      vim.lsp.config(srv.name, srv.config)
    end
    vim.lsp.enable(srv.name)
  end
end
