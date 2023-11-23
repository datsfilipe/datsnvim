local keymap = vim.keymap
keymap.set("n", "<leader>gg", ":Neogit<Return>", opts)

return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    local neogit = require "neogit"

    neogit.setup {
      disable_signs = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      signs = {
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
    }
  end
}
