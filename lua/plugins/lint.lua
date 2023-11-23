local linter = require "utils.config".linter

return {
  "mfussenegger/nvim-lint",
  event = "BufEnter",
  enabled = linter == "nvim-lint",
  config = function()
    local lint = require "lint"

    lint.linters_by_ft = {
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      dockerfile = { "hadolint" },
      markdown = { "markdownlint" },
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
