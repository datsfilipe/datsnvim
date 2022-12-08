local M = {}

local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local action_layout = require 'telescope.actions.layout'
local builtin = require 'telescope.builtin'
local fb_actions = require('telescope').extensions.file_browser.actions

M.actions = actions
M.action_state = action_state
M.action_layout = action_layout
M.builtin = builtin
M.fb_actions = fb_actions

return M
