return {
  {
    'wakatime/vim-wakatime',
    event = 'VeryLazy',
  },
  {
    'rawnly/gist.nvim',
    cmd = { 'GistCreate', 'GistCreateFromFile', 'GistsList' },
  },
  {
    'folke/todo-comments.nvim',
    event = 'BufEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  {
    'andweeb/presence.nvim',
    event = 'BufEnter',
  },
}
