local M = {}

local map = require('keymap.helper').map
local opts = { noremap = true, silent = true }

-- cmp
local ok, cmp = pcall(require, 'cmp')
if ok then
  M.cmp = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i' }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      { 'i' }
    ),
    ['<C-CR>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { 'i' }
    ),
  }
end

-- comment
map { 'n', '<leader>/', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', opts }
map { 'v', '<leader>/', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts }

-- diffview
map { 'n', '<leader>gd', ':DiffviewOpen<CR>', opts }
map { 'n', '<leader>gc', ':DiffviewClose<CR>', opts }
map { 'n', '<leader>ge', ':DiffviewToggleFiles<CR>', opts }
map { 'n', '<leader>gr', ':DiffviewRefresh<CR>', opts }
map { 'n', '<leader>gs', ':DiffviewToggleFiles<CR>', opts }

-- gitsigns
local ok, gitsigns = pcall(require, 'gitsigns')
if ok then
  M.gitsigns = function()
    nmap { '<leader>gs', ':Gitsigns stage_hunk<CR>' }
    nmap { '<leader>gr', ':Gitsigns reset_hunk<CR>' }
    vmap { '<leader>gs', ':Gitsigns stage_hunk<CR>' }
    vmap { '<leader>gr', ':Gitsigns reset_hunk<CR>' }
    nmap { '<leader>gu', gitsigns.undo_stage_hunk }
    nmap {
      '<leader>gb',
      function()
        gitsigns.blame_line { full = true }
      end,
    }
  end
end

-- harpoon
local ok, _ = pcall(require, 'harpoon')
if ok then
  local ui = require 'harpoon.ui'
  local mark = require 'harpoon.mark'

  map {
    'n',
    '<leader>hm',
    function()
      ui.toggle_quick_menu()
    end,
    opts,
  }
  map {
    'n',
    '<leader>ha',
    function()
      mark.add_file()
      print '[harpoon] mark added'
    end,
    opts,
  }
  map {
    'n',
    '<leader>hd',
    function()
      mark.rm_file(vim.fn.expand '%')
      print '[harpoon] mark deleted'
    end,
    opts,
  }
  map {
    'n',
    '<C-k>',
    function()
      ui.nav_prev()
    end,
    opts,
  }
  map {
    'n',
    '<C-j>',
    function()
      ui.nav_next()
    end,
    opts,
  }
end

-- lsp-zero
M.lspzero = function(_, bufnr)
  local lsp_opts = { buffer = bufnr, remap = false }

  nmap {
    'gd',
    function()
      vim.lsp.buf.definition()
    end,
    lsp_opts,
  }
  nmap {
    '<leader>vws',
    function()
      vim.lsp.buf.workspace_symbol()
    end,
    lsp_opts,
  }
  nmap {
    '<leader>vd',
    function()
      vim.diagnostic.open_float()
    end,
    lsp_opts,
  }
  nmap {
    '<leader>n',
    function()
      vim.diagnostic.goto_next()
    end,
    lsp_opts,
  }
  nmap {
    '<leader>p',
    function()
      vim.diagnostic.goto_prev()
    end,
    lsp_opts,
  }
  nmap {
    '<leader>vca',
    function()
      vim.lsp.buf.code_action()
    end,
    lsp_opts,
  }
  nmap {
    '<leader>vrr',
    function()
      vim.lsp.buf.references()
    end,
    lsp_opts,
  }
  nmap {
    '<leader>vrn',
    function()
      vim.lsp.buf.rename()
    end,
    lsp_opts,
  }
  imap {
    '<C-h>',
    function()
      vim.lsp.buf.signature_help()
    end,
    lsp_opts,
  }
end

-- neogit
map { 'n', '<leader>gg', '<cmd>Neogit<CR>', opts }

-- zenmode
local ok, zenmode = pcall(require, 'zen-mode')
if ok then
  map {
    'n',
    '<leader>z',
    function()
      zenmode.toggle()
    end,
  }
end

return M