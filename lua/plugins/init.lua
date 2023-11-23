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
    "folke/todo-comments.nvim",
    event = "BufEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
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
  {
    'echasnovski/mini.pairs',
    version = false,
    opts = {},
  },
}
