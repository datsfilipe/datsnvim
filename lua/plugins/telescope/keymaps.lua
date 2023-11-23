local M = {}

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

M.inner_maps = function(actions, action_layout, set_prompt_to_entry_value)
  return {
    i = {
      ["<C-x>"] = false,
      ["<C-c>"] = function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
      end,
      ["<C-j>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
      ["<C-d>"] = actions.results_scrolling_down,
      ["<C-u>"] = actions.results_scrolling_up,
      ["<C-l>"] = set_prompt_to_entry_value,
      ["<C-p>"] = action_layout.toggle_preview,
      ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      ["<C-g>a"] = actions.select_all,
      ["<C-g>s"] = actions.add_selection,
    },
    n = {
      ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      ["<C-d>"] = actions.results_scrolling_down,
      ["<C-u>"] = actions.results_scrolling_up,
    },
  }
end

M.outer_maps = function(extensions, builtin)
  keymap.set("n", ";h", function()
    extensions.harpoon.marks {
      prompt_prefix = "   ",
    }
  end, opts)

  keymap.set("n", ";f", function()
    builtin.find_files {
      prompt_prefix = "   ",
      no_ignore = false,
      hidden = true,
    }
  end, opts)

  keymap.set("n", ";r", function()
    builtin.live_grep {
      prompt_prefix = "   ",
    }
  end, opts)

  keymap.set("n", "\\\\", function()
    builtin.buffers {
      prompt_prefix = "   ",
    }
  end, opts)

  keymap.set("n", ";t", function()
    builtin.help_tags {
      prompt_prefix = "   ",
    }
  end, opts)

  keymap.set("n", ";e", function()
    builtin.diagnostics {
      prompt_prefix = "   ",
    }
  end, opts)

  keymap.set("n", ";k", function()
    builtin.keymaps {
      prompt_prefix = "   ",
    }
  end, opts)
end

return M
