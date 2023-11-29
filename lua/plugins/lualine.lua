local colorscheme = require "utils/config".colorscheme
if colorscheme == "oxocarbon" then
  colorscheme = "codedark"
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VimEnter",
  opts = {
    options = {
      icons_enabled = true,
      colorscheme,
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
