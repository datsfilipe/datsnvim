return {
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
  }
}
