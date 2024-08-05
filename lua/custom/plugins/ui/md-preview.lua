return {
  'datsfilipe/md-previewer',
  cmd = 'MdPreviewer',
  ft = 'markdown',
  build = 'bun install && bun compile',
  keys = {
    { '<F12>', '<cmd>MdPreviewer<cr>' },
  },
  opts = {
    quiet = true,
  },
}
