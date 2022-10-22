local present, telescope = pcall(require, 'telescope')
if not present then return end

local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require 'telescope'.extensions.file_browser.actions

telescope.setup {
  defaults = {
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    layout_strategy = 'flex',
    layout_config = {
      horizontal = {
        preview_width = 0.6,
      },
      prompt_position = 'top',
    },
    border = {},
    -- borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    -- borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    mappings = {
      n = {
        ['q'] = actions.close
      },
    },
    initial_mode = 'normal',
  },
  extensions = {
    file_browser = {
      theme = 'dropdown',
      hijack_netrw = true,
      respect_gitignore = false,
      hidden = true,
      grouped = true,
      mappings = {
        -- your custom insert mode mappings
        ['i'] = {
          -- go to normal mode
          ['<C-c>'] = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', true)
          end,
        },
        ['n'] = {
          ['N'] = fb_actions.create,
          ['/'] = function()
            vim.cmd('startinsert')
          end,
          -- maps for harpoon
          ['<C-b>'] = function()
            local entry = require('telescope.actions.state').get_selected_entry()
            local filename = entry.path
            local cmd = string.format(':lua require("harpoon.mark").add_file("%s")', filename)
            vim.cmd(cmd)
            actions.close()
          end,
          ['<C-B>'] = function()
            local entry = require('telescope.actions.state').get_selected_entry()
            local filename = entry.path
            local cmd = string.format(':lua require("harpoon.mark").rm_file("%s")', filename)
            vim.cmd(cmd)
            actions.close()
          end,
        }
      }
    }
  }
}

telescope.load_extension('file_browser')

vim.keymap.set('n', ';f', function()
  builtin.find_files({
    no_ignore = false,
    hidden = true,
    prompt_prefix = '   ',
  })
end)

vim.keymap.set('n', ';r', function()
  builtin.live_grep({
    prompt_prefix = '   ',
  })
end)

vim.keymap.set('n', '\\\\', function()
  builtin.buffers({
    prompt_prefix = '   ',
  })
end)

vim.keymap.set('n', ';t', function()
  builtin.help_tags({
    prompt_prefix = '   ',
  })
end)

vim.keymap.set('n', ';;', function()
  builtin.resume({
    prompt_prefix = ' גּ  ',
  })
end)

vim.keymap.set('n', ';e', function()
  builtin.diagnostics({
    prompt_prefix = '   ',
  })
end)

vim.keymap.set('n', 'sf', function()
  telescope.extensions.file_browser.file_browser({
    path = '%:p:h',
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    prompt_prefix = '   ',
  })
end)

vim.keymap.set('n', ';k', function()
  builtin.keymaps({
    prompt_title = 'keymaps',
    prompt_prefix = '   ',
  })
end)
