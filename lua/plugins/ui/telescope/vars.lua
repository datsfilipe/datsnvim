local M = {}

M.actions = require 'telescope.actions'
M.action_state = require 'telescope.actions.state'
M.action_layout = require 'telescope.actions.layout'
M.builtin = require 'telescope.builtin'
M.theme = require('telescope.themes').get_dropdown {}

return M
