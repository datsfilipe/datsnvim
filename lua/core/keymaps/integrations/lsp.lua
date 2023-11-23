local keymap = vim.keymap

return function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
  end, opts)

  keymap.set("n", "<leader>vws",
  function()
    vim.lsp.buf.workspace_symbol()
  end, opts)

  keymap.set("n", "<leader>vd", function()
    vim.diagnostic.open_float()
  end, opts)

  keymap.set("n", "<leader>n", function()
    vim.diagnostic.goto_next()
  end, opts)

  keymap.set("n", "<leader>p", function()
    vim.diagnostic.goto_prev()
  end, opts)

  keymap.set("n", "<leader>vca", function()
    vim.lsp.buf.code_action()
  end, opts)

  keymap.set("n", "<leader>vrr", function()
    vim.lsp.buf.references()
  end, opts)

  keymap.set("n", "<leader>vrn", function()
    vim.lsp.buf.rename()
  end, opts)

  keymap.set("i", "<C-h>", function()
    vim.lsp.buf.signature_help()
  end, opts)

  keymap.set("n", "K", function()
    vim.lsp.buf.hover()
  end, opts)
end
