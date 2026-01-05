vim.pack.add {
  'https://github.com/datsfilipe/console.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/wakatime/vim-wakatime',
}

vim.cmd.packadd 'cfilter'
vim.cmd.packadd 'nvim.undotree'
vim.cmd.packadd 'nvim.difftool'

vim.keymap.set('n', '<leader>f', '<cmd>LiveFiles<cr>')
vim.keymap.set('n', '<leader>r', '<cmd>LiveGrep<cr>')
vim.keymap.set('n', '<leader>C', '<cmd>ConsoleClose<cr>')
vim.keymap.set('n', '<leader>c', ':ConsoleRun ')
require('console').setup()

vim.keymap.set('n', '<Space>e', '<cmd>Oil<cr>')
require('oil').setup {
  keymaps = { ['`'] = 'actions.tcd', ['<C-q>'] = { 'actions.send_to_qflist', opts = { action = 'r' } } },
  columns = { 'size', 'mtime' },
  confirmation = { border = 'none' },
  view_options = { show_hidden = true },
  delete_to_trash = true,
  default_file_explorer = true,
  skip_confirm_for_simple_edits = true,
}

local ts = require 'nvim-treesitter'
local installed_list = ts.get_installed()
local installed = {}

for _, parser in ipairs(installed_list) do
  installed[parser] = true
end

local to_install = {}
for _, parser in ipairs {
  'bash',
  'c',
  'fish',
  'gitcommit',
  'graphql',
  'html',
  'javascript',
  'json',
  'json5',
  'kdl',
  'lua',
  'markdown',
  'markdown_inline',
  'nix',
  'query',
  'regex',
  'scss',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
} do
  if not installed[parser] then
    table.insert(to_install, parser)
  end
end

if #to_install > 0 then
  ts.install(to_install)
end

vim.cmd 'syntax off'
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    client.server_capabilities.semanticTokensProvider = nil

    if client.name == 'cssls' then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    if client:supports_method 'textDocument/completion' then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

vim.lsp.enable {
  'bashls',
  'biome',
  'cssls',
  'eslint',
  'gopls',
  'lua_ls',
  'nil_ls',
  'rust_analyzer',
  'solidity_ls',
  'ts_ls',
}
