local ok, lualine = pcall(require, "lualine")
if not ok then
  return
end

lualine.setup {
  options = {
    icons_enabled = true,
    theme = "min-theme",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {},
    lualine_x = {
      {
        "filename",
        file_status = true,
        path = 0,
      },
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {
      {
        "filename",
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
      },
    },
    lualine_y = {},
    lualine_z = { "location" },
  },
  tabline = {},
  extensions = {},
}