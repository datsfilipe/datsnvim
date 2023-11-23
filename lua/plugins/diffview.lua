local keymap = vim.keymap

keymap.set("n", "<leader>ge", "<cmd>DiffviewOpen<CR>", { remap = true })
keymap.set("n", "<leader>gx", "<cmd>DiffviewClose<CR>", { remap = true })
keymap.set("n", "<leader>gs", "<cmd>DiffviewToggleFiles<CR>", { remap = true })
keymap.set("n", "<leader>gr", "<cmd>DiffviewRefresh<CR>", { remap = true })

return {
  "sindrets/diffview.nvim",
  cmd = "DiffviewOpen",
  opts = {
    file_panel = {
      win_config = {
        width = 35,
      },
    },
    keymaps = {
      disable_defaults = false,
    },
  },
}
