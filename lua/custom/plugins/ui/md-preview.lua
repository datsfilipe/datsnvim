return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = 'markdown',
  keys = {
    { '<F12>', '<cmd>MarkdownPreviewToggle<CR>' },
  },
}
