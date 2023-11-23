local config = require "utils.config"

return {
  "shellRaining/hlchunk.nvim",
  event = { "UIEnter" },
  enabled = config.indent == "hlchunk",
  opts = {
    blank = {
      enable = false,
      notify = false,
    },
    chunk = {
      enable = false,
      notify = false,
    },
    indent = {
      enable = true,
      style = {
        { fg = config.indent_color },
      },
    },
    line_num = { enable = false },
  },
}
