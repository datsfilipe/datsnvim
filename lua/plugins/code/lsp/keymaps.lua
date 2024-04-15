local keymap = vim.keymap

local M = {}

M.on_attach = function(_, bufnr)
  local opts = { silent = true, buffer = bufnr }

  keymap.set('n', 'gd', function()
    vim.lsp.buf.definition()
  end, opts)

  keymap.set('n', '<leader>vws', function()
    vim.lsp.buf.workspace_symbol()
  end, opts)

  keymap.set('n', '<leader>vd', function()
    vim.diagnostic.open_float()
  end, opts)

  keymap.set('n', '<leader>vca', function()
    vim.lsp.buf.code_action()
  end, opts)

  keymap.set('n', '<leader>vrr', function()
    vim.lsp.buf.references()
  end, opts)

  keymap.set('n', '<leader>vrn', function()
    vim.lsp.buf.rename()
  end, opts)

  keymap.set('i', '<C-h>', function()
    vim.lsp.buf.signature_help()
  end, opts)

  keymap.set('n', 'K', function()
    vim.lsp.buf.hover()
  end, opts)

  keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  keymap.set('n', 'gD', '<cmd>Telescope lsp_type_definitions<CR>', opts)
  keymap.set('n', 'gI', '<cmd>Telescope lsp_implementations<CR>', opts)
  keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  keymap.set('n', '<leader>ld', '<cmd>Telescope diagnostics<cr>', opts)
end

return M
