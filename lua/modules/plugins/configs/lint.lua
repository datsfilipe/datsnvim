local ok, lint = pcall(require, "lint")
if not ok then
  return
end

lint.linters_by_ft = {
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})