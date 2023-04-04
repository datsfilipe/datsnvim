local present, diffview = pcall(require, 'diffview')
if not present then
  return
end

local actions = require 'diffview.actions'

diffview.setup {
  file_panel = {
    win_config = {
      width = 35,
    },
  },
  key_bindings = {
    disable_defaults = false, -- Disable the default key bindings
    view = {
      { 'n', '<tab>', actions.select_next_entry },
      { 'n', '<s-tab>', actions.select_prev_entry },
      { 'n', '<C-w>gf', actions.goto_file_tab },
      { 'n', '<leader>e', actions.focus_files },
      { 'n', '<leader>b', actions.toggle_files },
      -- conflict resolution
      { 'n', '<leader>ck', actions.prev_conflict },
      { 'n', '<leader>cj', actions.next_conflict },
      { 'n', '<leader>co', actions.conflict_choose 'ours' },
      { 'n', '<leader>ct', actions.conflict_choose 'theirs' },
      { 'n', '<leader>cb', actions.conflict_choose 'base' },
      { 'n', '<leader>ca', actions.conflict_choose 'all' },
      { 'n', 'dx', actions.conflict_choose 'none' },
    },
    file_panel = {
      { 'n', '<leader>ck', actions.prev_conflict },
      { 'n', '<leader>cj', actions.next_conflict },
      { 'n', '<leader>dc', actions.open_commit_log },
    },
  },
}
