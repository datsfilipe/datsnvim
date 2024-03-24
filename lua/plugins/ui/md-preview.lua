return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = 'markdown',
  build = 'cd app && npm install',
  config = function()
    local keymap = vim.keymap
    keymap.set(
      'n',
      '<F12>',
      '<cmd>MarkdownPreviewToggle<CR>',
      { noremap = true, silent = true }
    )
  end,
}
