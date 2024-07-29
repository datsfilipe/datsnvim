return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = 'markdown',
  build = 'cd app && yarn install',
  keys = {
    { '<F12>', '<cmd>MarkdownPreviewToggle<CR>' },
  },
}
