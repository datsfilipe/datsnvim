return {
  "nvim-lualine/lualine.nvim",
  event = "VimEnter",
  opts = {
    options = {
      icons_enabled = true,
      require "utils/config".colorscheme,
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        {
          "filename",
          file_status = true,
          path = 1,
        },
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        {
          "diagnostics",
          symbols = {
            error = "●" .. " ",
            warn = "●" .. " ",
            info = "●" .. " ",
            hint = "●" .. " ",
          },
        },
        "progress",
      },
      lualine_z = {
        "branch",
        "diff",
      },
    },
    tabline = {},
    extensions = {},
  }
}
