return {
  "folke/zen-mode.nvim",
  event = "VeryLazy",
  config = function()
    local keymap = vim.keymap

    keymap.set(
      "n",
      "<leader>z",
      function()
        require "zen-mode".toggle()
      end
    )
  end,
}
