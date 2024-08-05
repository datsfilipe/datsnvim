return {
  'datsfilipe/md-previewer',
  cmd = 'MdPreviewer',
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  build = ":lua dofile(vim.fn.stdpath('data') .. '/lazy/md-previewer/lua/build.lua')",
  keys = {
    { '<F12>', '<cmd>MdPreviewer<cr>' },
  },
  opts = {
    quiet = true,
  },
}
