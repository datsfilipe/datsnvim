local ok, conform = pcall(require, "conform")
if not ok then
  return
end

require("conform.formatters.stylua").require_cwd = true

conform.setup {
  formatters_by_ft = {
    lua = { "stylua" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    conform.format { bufnr = args.buf, lsp_fallback = true }
  end,
})
