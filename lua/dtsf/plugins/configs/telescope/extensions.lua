local M = {}

local actions = require('dtsf.plugins.configs.telescope.vars').actions
local action_state = require('dtsf.plugins.configs.telescope.vars').action_state
local fb_actions = require('dtsf.plugins.configs.telescope.vars').fb_actions

local extensions = {
  fzf = {
    fuzzy = true,
    override_generic_sorter = true,
    override_file_sorter = true,
    case_mode = 'smart_case',
  },
  file_browser = {
    hijack_netrw = true,
    git_status = false,
    display_stat = { date = true, size = true },
    hidden = true,
    grouped = true,
    theme = 'dropdown',
    mappings = {
      n = {
        ['N'] = fb_actions.create,
        -- maps for harpoon
        ['<C-h>h'] = function(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          local path = entry.path
          vim.cmd('lua require(\'harpoon.mark\').add_file(\'' .. path .. '\')')
          actions.close(prompt_bufnr)
        end,
        ['<C-h>l'] = function(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          local path = entry.path
          vim.cmd('lua require(\'harpoon.mark\').rm_file(\'' .. path .. '\')')
          actions.close(prompt_bufnr)
        end,
      },
      i = {
        ['<C-N>'] = fb_actions.create,
        -- maps for harpoon
        ['<C-h>b'] = function(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          local path = entry.path
          vim.cmd('lua require(\'harpoon.mark\').add_file(\'' .. path .. '\')')
          actions.close(prompt_bufnr)
        end,
        ['<C-h>r'] = function(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          local path = entry.path
          vim.cmd('lua require(\'harpoon.mark\').rm_file(\'' .. path .. '\')')
          actions.close(prompt_bufnr)
        end,
      },
    },
  },
}

M.extensions = extensions

return M