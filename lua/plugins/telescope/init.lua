return {
  "nvim-telescope/telescope.nvim",
  event = "BufEnter",
  config = function()
    local telescope = require "telescope"

    local maps = require "plugins.telescope.keymaps"
    local actions = require("plugins.telescope.vars").actions
    local action_state = require("plugins.telescope.vars").action_state
    local action_layout = require("plugins.telescope.vars").action_layout
    local extensions = require("plugins.telescope.extensions").extensions
    local builtin = require("plugins.telescope.vars").builtin

    local set_prompt_to_entry_value = function(prompt_bufnr)
      local entry = action_state.get_selected_entry()
      if not entry or not type(entry) == "table" then
        return
      end

      action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
    end

    telescope.setup {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        border = {},
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
        -- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        layout_strategy = "flex",
        sorting_strategy = "ascending",
        mappings = maps.inner_maps(actions, action_layout, set_prompt_to_entry_value),
      },
      extensions = extensions,
    }

    telescope.load_extension "harpoon"
    telescope.load_extension "fzf"

    maps.outer_maps(telescope.extensions, builtin)
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-dap.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
}
