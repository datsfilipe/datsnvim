return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false,
  opts = {
    provider = 'ollama',
    ollama = {
      endpoint = 'http://localhost:11434',
      model = 'qwen2.5-coder:14b',
    },
  },
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
}
