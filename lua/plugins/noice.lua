return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {},
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      event = "BufEnter",
      opts = {
        background_colour = "#000000",
        fps = 60,
        render = "wrapped-compact",
        stages = "slide",
        timeout = 4000,
        top_down = true
      },
    },
  },
}
