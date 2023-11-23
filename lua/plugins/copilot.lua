return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enable = true,
      auto_trigger = true,
      keymap = {
        accept = "<C-Space>"
      }
    }
  },
}
