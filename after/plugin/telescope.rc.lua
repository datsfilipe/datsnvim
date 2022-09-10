local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          -- go to normal mode
          ['<C-c>'] = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', true)
          end,
        },
        ["n"] = {
          ["N"] = fb_actions.create,
          ["/"] = function()
            vim.cmd('startinsert')
          end,
          -- maps for harpoon
          ["<C-b>"] = function()
            local entry = require('telescope.actions.state').get_selected_entry()
            local filename = entry.path
            local cmd = string.format(":lua require('harpoon.mark').add_file('%s')", filename)
            vim.cmd(cmd)
            actions.close()
          end,
          ["<C-B>"] = function()
            local entry = require('telescope.actions.state').get_selected_entry()
            local filename = entry.path
            local cmd = string.format(":lua require('harpoon.mark').rm_file('%s')", filename)
            vim.cmd(cmd)
            actions.close()
          end,
        },
      },
    },
  },
}

telescope.load_extension("file_browser")

vim.keymap.set('n', ';f',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true,
      prompt_prefix = "﬌ ",
    })
  end)
vim.keymap.set('n', ';r', function()
  builtin.live_grep({
    prompt_prefix = ' '
  })
end)
vim.keymap.set('n', '\\\\', function()
  builtin.buffers({
    prompt_prefix = "﬌ ",
  })
end)
vim.keymap.set('n', ';t', function()
  builtin.help_tags({
    prompt_prefix = "﬌ ",
  })
end)
vim.keymap.set('n', ';;', function()
  builtin.resume({
    layout_config = {
      width = 0.4,
      height = 0.8,
      prompt_position = "top",
    },
    prompt_prefix = "﬌ ",
  })
end)
vim.keymap.set('n', ';e', function()
  builtin.diagnostics({
    prompt_prefix = "﬌ ",
  })
end)
vim.keymap.set("n", "sf", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    prompt_prefix = "﬌ ",
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.8,
      height = 0.8,
      prompt_position = "top",
    },
  })
end)

vim.keymap.set('n', ';k', function()
  builtin.keymaps({
    layout_config = {
      height = 20,
      width = 80,
      prompt_position = "top",
      preview_cutoff = 120,
    },
    prompt_title = "Keymaps",
    prompt_prefix = "  ",
  })
end)
