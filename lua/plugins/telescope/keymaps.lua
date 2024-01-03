local M = {}

local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local theme = require('plugins.telescope.vars').theme

M.inner_maps = function(actions, _, set_prompt_to_entry_value)
  return {
    i = {
      ['<C-x>'] = false,
      ['<C-c>'] = function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', true)
      end,
      ['<C-j>'] = actions.move_selection_next,
      ['<C-k>'] = actions.move_selection_previous,
      ['<C-d>'] = actions.results_scrolling_down,
      ['<C-u>'] = actions.results_scrolling_up,
      ['<C-l>'] = set_prompt_to_entry_value,
      ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
      ['<C-a>'] = actions.add_selection,
      ['<C-g>a'] = actions.select_all,
    },
    n = {
      ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
      ['<C-d>'] = actions.results_scrolling_down,
      ['<C-u>'] = actions.results_scrolling_up,
    },
  }
end

M.outer_maps = function(extensions, builtin)
  keymap.set('n', ';h', function()
    extensions.harpoon.marks(vim.tbl_deep_extend('force', {
      prompt_prefix = '   ',
    }, theme))
  end, opts)

  keymap.set('n', ';f', function()
    builtin.find_files(vim.tbl_deep_extend('force', {
      prompt_prefix = '   ',
      no_ignore = false,
      hidden = true,
    }, theme))
  end, opts)

  keymap.set('n', ';r', function()
    builtin.live_grep(vim.tbl_deep_extend('force', {
      prompt_prefix = '   ',
    }, theme))
  end, opts)

  keymap.set('n', '\\\\', function()
    builtin.buffers(vim.tbl_deep_extend('force', {
      prompt_prefix = '   ',
    }, theme))
  end, opts)

  keymap.set('n', ';t', function()
    builtin.help_tags(vim.tbl_deep_extend('force', {
      prompt_prefix = '   ',
    }, theme))
  end, opts)

  keymap.set('n', ';k', function()
    builtin.keymaps(vim.tbl_deep_extend('force', {
      prompt_prefix = '   ',
    }, theme))
  end, opts)
end

return M
