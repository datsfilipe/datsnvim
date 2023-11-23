local keymap = vim.keymap

keymap.set(
  "n",
  "<leader>z",
  function()
    zenmode.toggle()
  end
)
