local ok, lint = pcall(require, "lint")
if not ok then
  return
end

lint.linters_by_ft = {
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})