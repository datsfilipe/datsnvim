---@diagnostic disable: assign-type-mismatch

vim.pack.add {
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvimdev/indentmini.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/wakatime/vim-wakatime',
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
    data = {
      on_update = function()
        require('nvim-treesitter').install {
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
        }
      end,
    },
  },
}

vim.cmd.packadd 'cfilter'
vim.cmd.packadd 'nvim.undotree'
vim.cmd.packadd 'nvim.difftool'

require('indentmini').setup {}

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

vim.keymap.set('n', '<leader>w', function()
  require('fzf-lua').lgrep_curbuf {
    winopts = {
      height = 0.6,
      width = 0.5,
    },
    fzf_opts = { ['--layout'] = 'reverse' },
  }
end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b', '<cmd>FzfLua buffers<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>h', '<cmd>FzfLua highlights<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>m', '<cmd>FzfLua help_tags<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>d', '<cmd>FzfLua lsp_document_diagnostics<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>f', '<cmd>FzfLua files<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>o', '<cmd>FzfLua oldfiles<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>r', '<cmd>FzfLua live_grep<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'z=', '<cmd>FzfLua spell_suggest<cr>', { noremap = true, silent = true })

local actions = require 'fzf-lua.actions'

require('fzf-lua').setup {
  { 'ivy', 'borderless', 'hide', 'max-perf' },
  fzf_opts = {
    ['--info'] = 'default',
    ['--layout'] = 'reverse-list',
  },
  fzf_colors = {
    bg = { 'bg', 'Normal' },
    gutter = { 'bg', 'Normal' },
    info = { 'fg', 'Conditional' },
    scrollbar = { 'bg', 'Normal' },
    separator = { 'fg', 'Comment' },
  },
  ---@diagnostic disable-next-line: missing-fields
  winopts = { preview = { hidden = true } },
  defaults = { git_icons = false },
  keymap = {
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
  oldfiles = { include_current_session = true },
  helptags = {
    actions = { ['enter'] = actions.help_vert },
  },
  lsp = {
    code_actions = { winopts = { relative = 'cursor' } },
  },
  diagnostics = {
    multiline = 1,
    diag_icons = {
      ['Error'] = 'E ',
      ['Warn'] = 'W ',
      ['Info'] = 'I ',
      ['Hint'] = 'H ',
    },
  },
}
