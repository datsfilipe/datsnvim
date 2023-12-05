return {
  "iamcco/markdown-preview.nvim",
  ft = "markdown",
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  config = function()
    local keymap = vim.keymap
    keymap.set("n", "<F12>", "<cmd>MarkdownPreviewToggle<CR>", { noremap = true, silent = true })
  end,
}
