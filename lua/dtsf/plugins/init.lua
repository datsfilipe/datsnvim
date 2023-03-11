return {
  {
    'L3MON4D3/LuaSnip',
    config = function()
      require 'dtsf.plugins.configs.luasnip'
    end,
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    config = function()
      require 'dtsf.plugins.configs.lualine'
    end,
  },
  {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require 'dtsf.plugins.configs.nvim-web-devicons'
    end,
  },
  {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require 'dtsf.plugins.configs.web-devicons'
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require 'dtsf.plugins.configs.telescope'
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-dap.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
    },
  },
  {
    'kylechui/nvim-surround',
    config = function()
      require 'dtsf.plugins.configs.surround'
    end,
  },
  {
    'ThePrimeagen/harpoon',
    config = function()
      require 'dtsf.plugins.configs.harpoon'
    end,
  },
  {
    'dinhhuy258/git.nvim',
    config = function()
      require 'dtsf.plugins.configs.git'
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
    'lewis6991/gitsigns.nvim',
    config = function()
      require 'dtsf.plugins.configs.gitsigns'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'dtsf.plugins.configs.treesitter'
    end,
    build = function()
      local ts_update = require('nvim-treesitter.install').update { with_sync = true }
      ts_update()
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      config = function()
        require 'dtsf.plugins.configs.treesitter-context'
      end,
    },
  },
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    config = function()
      require 'dtsf.plugins.configs.dap'
    end,
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
    },
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require 'dtsf.plugins.configs.mason'
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = true,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require 'dtsf.plugins.configs.lspconfig'
    end,
  },
  {
    'glepnir/lspsaga.nvim',
    config = function()
      require 'dtsf.plugins.configs.lspsaga'
    end,
  },
  {
    'onsails/lspkind-nvim',
    config = function()
      require 'dtsf.plugins.configs.lspkind'
    end,
  },
  {
    'folke/lsp-colors.nvim',
    config = function()
      require 'dtsf.plugins.configs.lspcolors'
    end,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require 'dtsf.plugins.configs.null-ls'
    end,
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require 'dtsf.plugins.configs.comment'
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function()
      require 'dtsf.plugins.configs.cmp'
    end,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      {
        'zbirenbaum/copilot-cmp',
        config = function()
          require('copilot_cmp').setup()
        end,
      },
      {
        'zbirenbaum/copilot.lua',
        config = function()
          require('copilot').setup {}
        end,
      },
    },
  },
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require 'dtsf.plugins.configs.ts-autotag'
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require 'dtsf.plugins.configs.blankline'
    end,
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      require 'dtsf.plugins.configs.autopairs'
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require 'dtsf.plugins.configs.colorizer'
    end,
  },
  {
    'nyoom-engineering/oxocarbon.nvim',
    lazy = true,
    -- priority = 1000,
    config = function()
      require 'dtsf.plugins.configs.oxocarbon'
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require 'dtsf.plugins.configs.gruvbox'
    end,
  },
}
