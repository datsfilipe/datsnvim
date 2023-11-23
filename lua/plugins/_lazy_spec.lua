local colorscheme = require("utils/colorscheme")

return {
  -- LSP Support
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    event = "BufEnter",
    config = function()
      require "plugins.lsp"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
  },
  {
    "williamboman/mason.nvim",
    event = "BufEnter",
    build = ":MasonUpdate",
    config = function()
      require "plugins.mason"
    end,
  },
  "williamboman/mason-lspconfig.nvim",
  -- autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require "plugins.cmp"
    end,
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
    config = function()
      require "plugins.treesitter"
    end,
    build = function()
      local ts_update = require("nvim-treesitter.install").update { with_sync = true }
      ts_update()
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {},
      },
      "nvim-treesitter/playground",
    },
  },
  {
    "stevearc/conform.nvim",
    event = "BufEnter",
  },
  {
    "mfussenegger/nvim-lint",
    event = "BufEnter",
  },
  -- utilities
  {
    "nvim-telescope/telescope.nvim",
    event = "BufEnter",
    config = function()
      require "plugins.telescope"
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
    event = "BufEnter",
    config = function()
      require "plugins.harpoon"
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
    event = "VeryLazy",
  },
  {
    "numToStr/Comment.nvim",
    cmd = "CommentToggle",
    opts = {},
  },
  {
    "rawnly/gist.nvim",
    event = "VeryLazy",
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require "plugins.copilot"
    end,
  },
  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    config = function()
      require "plugins.zenmode"
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    version = "1.*",
    build = "make install_jsregexp",
    event = "InsertEnter",
    config = function()
      require "plugins.luasnip"
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
      require "plugins.neogit"
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    config = function()
      require "plugins.diffview"
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    config = function()
      require "plugins.gitsigns"
    end,
  },
  -- ui
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
      require "plugins.lualine"
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = { "*" },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = "VeryLazy",
    config = function()
      require "plugins.indent"
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {},
      default = true,
    },
  },
  {
    "andweeb/presence.nvim",
    lazy = false,
  },
  -- colorschemes
  {
    "datsfilipe/min-theme.nvim",
    lazy = false,
    priority = 1000,
    enabled = colorscheme == "min-theme",
    config = function()
      require "plugins.colorschemes.min-theme"
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    enabled = colorscheme == "gruvbox",
    config = function()
      require 'plugins.colorschemes.gruvbox'
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    enabled = colorscheme == "catppuccin",
    config = function()
      require 'plugins.colorschemes.catppuccin'
    end,
  },
}
