local config = require 'utils.config'

return {
  'nvim-treesitter/nvim-treesitter',
  config = function()
    local parser_config =
      require('nvim-treesitter.parsers').get_parser_configs()
    parser_config.tsx.filetype_to_parsername =
      { 'javascript', 'typescript.tsx' }

    vim.filetype.add {
      extension = {
        mdx = 'mdx',
      },
    }

    vim.treesitter.language.register('markdown', 'mdx')

    require('nvim-treesitter.configs').setup {
      auto_install = true,
      sync_install = false,
      highlight = { enable = true },
      ensure_installed = config.parsers,
      autotag = { enable = true },
      incremental_selection = { enable = false },
      rainbow = { enable = false },
    }
  end,
  build = function()
    local ts_update =
      require('nvim-treesitter.install').update { with_sync = true }
    ts_update()
  end,
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-context',
      cmd = { 'TSContextEnable', 'TSContextDisable' },
      opts = { mode = 'cursor', max_lines = 3 },
      keys = {
        {
          '<leader>ct',
          function()
            local tsc = require 'treesitter-context'
            tsc.toggle()
          end,
        },
      },
    },
    'nvim-treesitter/playground',
  },
}
