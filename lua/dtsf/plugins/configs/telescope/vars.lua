local M = {}

local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local action_layout = require 'telescope.actions.layout'
local builtin = require 'telescope.builtin'

M.actions = actions
M.action_state = action_state
M.action_layout = action_layout
M.builtin = builtin

return M
