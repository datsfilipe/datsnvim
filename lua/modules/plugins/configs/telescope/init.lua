local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end

local maps = require('keymap.plugins.telescope')

local actions = require('modules.plugins.configs.telescope.vars').actions
local action_state = require('modules.plugins.configs.telescope.vars').action_state
local action_layout = require('modules.plugins.configs.telescope.vars').action_layout
local extensions = require('modules.plugins.configs.telescope.extensions').extensions
local builtin = require('modules.plugins.configs.telescope.vars').builtin

local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not type(entry) == 'table' then
    return
  end

  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

telescope.setup {
  defaults = {
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    border = {},
    borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    -- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    layout_strategy = 'flex',
    sorting_strategy = 'ascending',
    mappings = maps.inner_maps(actions, action_layout, set_prompt_to_entry_value)
  },
  extensions = extensions,
}

telescope.load_extension 'harpoon'
telescope.load_extension 'fzf'

maps.outer_maps(telescope.extensions, builtin)