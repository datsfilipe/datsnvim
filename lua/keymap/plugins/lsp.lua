local map = require("scripts.map")

return function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  map {
    "n",
    "gd",
    function()
      vim.lsp.buf.definition()
    end,
    opts,
  }
  map {
    "n",
    "<leader>vws",
    function()
      vim.lsp.buf.workspace_symbol()
    end,
    opts,
  }
  map {
    "n",
    "<leader>vd",
    function()
      vim.diagnostic.open_float()
    end,
    opts,
  }
  map {
    "n",
    "<leader>n",
    function()
      vim.diagnostic.goto_next()
    end,
    opts,
  }
  map {
    "n",
    "<leader>p",
    function()
      vim.diagnostic.goto_prev()
    end,
    opts,
  }
  map {
    "n",
    "<leader>vca",
    function()
      vim.lsp.buf.code_action()
    end,
    opts,
  }
  map {
    "n",
    "<leader>vrr",
    function()
      vim.lsp.buf.references()
    end,
    opts,
  }
  map {
    "n",
    "<leader>vrn",
    function()
      vim.lsp.buf.rename()
    end,
    opts,
  }
  map {
    "i",
    "<C-h>",
    function()
      vim.lsp.buf.signature_help()
    end,
    opts,
  }
  map {
    "n",
    "K",
    function()
      vim.lsp.buf.hover()
    end,
    opts,
  }
end