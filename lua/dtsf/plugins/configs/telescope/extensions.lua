local M = {}

local actions = require('dtsf.plugins.configs.telescope.vars').actions
local action_state = require('dtsf.plugins.configs.telescope.vars').action_state

local extensions = {
  fzf = {
    fuzzy = true,
    override_generic_sorter = true,
    override_file_sorter = true,
    case_mode = 'smart_case',
  },
}

M.extensions = extensions

return M
