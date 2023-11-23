local keymap = vim.keymap

keymap.set("n", "<leader>S", ":lua require('spectre').toggle()<CR>", { noremap = true, silent = true })

return {
  "nvim-pack/nvim-spectre",
  event = "VeryLazy",
  opts = {},
}
