return {
  'olimorris/codecompanion.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    strategies = {
      chat = {
        adapter = 'ollama',
        keymaps = {
          send = {
            modes = { n = '<Enter>', i = '<C-g>' },
          },
          close = {
            modes = { n = '<Esc>', i = '<Esc>' },
          },
        },
      },
      inline = { adapter = 'ollama' },
      cmd = { adapter = 'ollama' },
    },
    adapters = {
      ollama = function()
        return require('codecompanion.adapters').extend('ollama', {
          schema = {
            model = {
              default = 'qwen2.5-coder:14b',
            },
          },
        })
      end,
    },
  },
}
