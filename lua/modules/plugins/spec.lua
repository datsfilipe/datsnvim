return {
  -- LSP support
  { "neovim/nvim-lspconfig" },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
  },
  "williamboman/mason-lspconfig.nvim",
  -- autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    priority = 500,
    config = function()
      require "modules.plugins.configs.treesitter"
    end,
    build = function()
      local ts_update = require("nvim-treesitter.install").update { with_sync = true }
      ts_update()
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require("treesitter-context").setup {}
        end,
      },
      "nvim-treesitter/playground",
    },
  },
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = "BufEnter",
  },
  {
    "mfussenegger/nvim-lint",
    lazy = true,
    event = "BufEnter",
  },
  -- utilities
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = "BufEnter",
    config = function()
      require "modules.plugins.configs.telescope"
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-dap.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    lazy = true,
    event = "BufEnter",
    config = function()
      require "modules.plugins.configs.harpoon"
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "wakatime/vim-wakatime",
    lazy = true,
    event = "VeryLazy",
  },
  {
    "numToStr/Comment.nvim",
    cmd = "CommentToggle",
    config = function()
      require "modules.plugins.configs.comment"
    end,
  },
  {
    "rawnly/gist.nvim",
    lazy = true,
    event = "VeryLazy",
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = true,
    event = "InsertEnter",
  },
  {
    "windwp/nvim-autopairs",
    lazy = true,
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "vim" },
      }
    end,
  },
  {
    "github/copilot.vim",
    lazy = true,
    event = "InsertEnter",
    config = function()
      require "modules.plugins.configs.copilot"
    end,
  },
  {
    "folke/zen-mode.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function()
      require "modules.plugins.configs.zenmode"
    end,
  },
  {
    "folke/todo-comments.nvim",
    lazy = true,
    event = "BufEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup {}
    end,
  },
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    version = "1.*",
    build = "make install_jsregexp",
    lazy = true,
    event = "InsertEnter",
    config = function()
      require "modules.plugins.configs.luasnip"
    end,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },
  -- git
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require "modules.plugins.configs.neogit"
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    config = function()
      require "modules.plugins.configs.diffview"
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    cmd = "Gitsigns",
    config = function()
      require "modules.plugins.configs.gitsigns"
    end,
  },
  -- ui
  {
    "nvim-lualine/lualine.nvim",
    lazy = true,
    event = "VimEnter",
    config = function()
      require "modules.plugins.configs.lualine"
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    lazy = true,
    event = "VeryLazy",
    config = function()
      require("colorizer").setup {
        "*",
      }
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function()
      require "modules.plugins.configs.indent"
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup {
        override = {},
        default = true,
      }
    end,
  },
  -- colorschemes
  {
    "datsfilipe/min-theme.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require "modules.plugins.configs.colorschemes.min-theme"
    end,
  },
}