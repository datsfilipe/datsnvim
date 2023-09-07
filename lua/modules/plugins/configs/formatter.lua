local ok, formatter = pcall(require, "formatter")
if not ok then
  return
end

formatter.setup {
  logging = true,
  filetype = {
    typescript = {
      require("formatter.filetypes.typescript").eslint_d,
    },
    typescriptreact = {
      require("formatter.filetypes.typescript").eslint_d,
    },
    lua = {
      require("formatter.filetypes.lua").stylua,
    },
  },
}