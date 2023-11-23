local keymap = vim.keymap

keymap.set("n", "<leader>T", ":TroubleToggle<CR>", { noremap = true, silent = true })

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {}
}
