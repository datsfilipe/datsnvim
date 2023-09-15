local present, diffview = pcall(require, "diffview")
if not present then
  return
end

diffview.setup {
  file_panel = {
    win_config = {
      width = 25,
    },
  },
  key_bindings = {
    disable_defaults = false,
  },
}