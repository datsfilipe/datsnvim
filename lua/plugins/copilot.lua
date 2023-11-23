local ok, copilot = pcall(require, "copilot")
if not ok then
  return
end

copilot.setup({
  suggestion = {
    enable = true,
    auto_trigger = true,
    keymap = {
      accept = "<C-Space>"
    }
  }
})
