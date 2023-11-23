return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      local keymap = vim.keymap
      keymap.set("n", "<F12>", "<cmd>MarkdownPreviewToggle<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
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
    "folke/todo-comments.nvim",
    event = "BufEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = { "*" },
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
}
