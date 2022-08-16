local status, colors = pcall(require, "lsp-colors")
if (not status) then return end

colors.setup {
  Error = "#cf2121",
  Warning = "#e0af68",
  Information = "#33b1ff",
  Hint = "#42be65"
}
