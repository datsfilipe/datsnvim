return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    config = function()
      require 'modules.plugins.configs.lsp'
    end,
    dependencies = {
      -- LSP support
      { 'neovim/nvim-lspconfig' },
      {
        'williamboman/mason.nvim',
        build = ':MasonUpdate',
      },
      { 'williamboman/mason-lspconfig.nvim' },
      -- autocompletion
      {
        'hrsh7th/nvim-cmp',
        lazy = true,
        event = 'InsertEnter',
      },
      {
        'hrsh7th/cmp-nvim-lsp',
        config = function()
          require 'modules.plugins.configs.cmp'
        end,
      },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'modules.plugins.configs.treesitter'
    end,
    build = function()
      local ts_update = require('nvim-treesitter.install').update { with_sync = true }
      ts_update()
    end,
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
          require('treesitter-context').setup {}
        end,
      },
      'nvim-treesitter/playground',
    },
  },
  -- utilities
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    config = function()
      require 'modules.plugins.configs.telescope'
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-dap.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      'nvim-telescope/telescope-file-browser.nvim',
    },
  },
  {
    'ThePrimeagen/harpoon',
    config = function()
      require 'modules.plugins.configs.harpoon'
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    ft = 'markdown',
  },
  { 'wakatime/vim-wakatime' },
  {
    'numToStr/Comment.nvim',
    config = function()
      require 'modules.plugins.configs.comment'
    end,
  },
  {
    'rawnly/gist.nvim',
    lazy = true,
    event = 'BufWinEnter',
  },
  {
    'windwp/nvim-ts-autotag',
    lazy = true,
    event = 'InsertEnter',
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {
        disable_filetype = { 'TelescopePrompt', 'vim' },
      }
    end,
  },
  {
    'github/copilot.vim',
    config = function()
      require 'modules.plugins.configs.copilot'
    end,
  },
  {
    'folke/zen-mode.nvim',
    lazy = true,
    event = 'InsertEnter',
    config = function()
      require 'modules.plugins.configs.zenmode'
    end,
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('todo-comments').setup {}
    end,
  },
  -- snippets
  {
    'L3MON4D3/LuaSnip',
    version = '1.*',
    build = 'make install_jsregexp',
    config = function()
      require 'modules.plugins.configs.luasnip'
    end,
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
  },
  -- git
  {
    'NeogitOrg/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require 'modules.plugins.configs.neogit'
    end,
  },
  {
    'sindrets/diffview.nvim',
    config = function()
      require 'modules.plugins.configs.diffview'
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require 'modules.plugins.configs.gitsigns'
    end,
  },
  -- ui
  {
    'goolord/alpha-nvim',
    lazy = true,
    event = 'VimEnter',
    config = function()
      require 'modules.plugins.configs.alpha'
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VimEnter',
    config = function()
      require 'modules.plugins.configs.lualine'
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup {
        '*',
      }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufWinEnter',
    config = function()
      require 'modules.plugins.configs.blankline'
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        override = {},
        default = true,
      }
    end,
  },
  -- colorschemes
  {
    'datsfilipe/min-theme.nvim',
    priority = 1000,
    config = function()
      require 'modules.plugins.configs.colorschemes.min-theme'
    end,
  },
}