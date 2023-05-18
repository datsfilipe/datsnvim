local nmap = require('dtsf.utils').nmap
local imap = require('dtsf.utils').imap

local ok, lsp = pcall(require, 'lsp-zero')
if not ok then
  return
end

lsp.preset 'recommended'

lsp.ensure_installed {
  'rust_analyzer',
  'tsserver',
  'tailwindcss',
  'lua_ls',
}

lsp.set_sign_icons {
  error = '',
  warn = '',
  hint = '',
  info = '',
}

lsp.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  nmap {
    'gd',
    function()
      vim.lsp.buf.definition()
    end,
    opts,
  }
  nmap {
    '<leader>vws',
    function()
      vim.lsp.buf.workspace_symbol()
    end,
    opts,
  }
  nmap {
    '<leader>vd',
    function()
      vim.diagnostic.open_float()
    end,
    opts,
  }
  nmap {
    '<leader>n',
    function()
      vim.diagnostic.goto_next()
    end,
    opts,
  }
  nmap {
    '<leader>p',
    function()
      vim.diagnostic.goto_prev()
    end,
    opts,
  }
  nmap {
    '<leader>vca',
    function()
      vim.lsp.buf.code_action()
    end,
    opts,
  }
  nmap {
    '<leader>vrr',
    function()
      vim.lsp.buf.references()
    end,
    opts,
  }
  nmap {
    '<leader>vrn',
    function()
      vim.lsp.buf.rename()
    end,
    opts,
  }
  imap {
    '<C-h>',
    function()
      vim.lsp.buf.signature_help()
    end,
    opts,
  }
end)

-- fix undefined global 'vim'
require('lspconfig').lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
}

require('lspconfig').unocss.setup {
  cmd = { 'unocss-language-server', '--stdio' },
  filetypes = { 'html', 'javascriptreact', 'rescript', 'typescriptreact', 'vue', 'svelte' },
  root_dir = require('lspconfig').util.root_pattern('package.json', 'tsconfig.json', '.git'),
}

-- lsp.format_on_save {
--   servers = {
--     ['rust_analyzer'] = { 'rust' },
--   },
-- }

lsp.setup()

vim.diagnostic.config {
  virtual_text = true,
}