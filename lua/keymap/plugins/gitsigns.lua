local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then
  return
end

local map = require('keymap.helper').map

return function()
  map { 'n', '<leader>gs', ':Gitsigns stage_hunk<CR>' }
  map { 'n', '<leader>gr', ':Gitsigns reset_hunk<CR>' }
  map { 'v', '<leader>gs', ':Gitsigns stage_hunk<CR>' }
  map { 'v', '<leader>gr', ':Gitsigns reset_hunk<CR>' }
  map { 'n', '<leader>gu', gitsigns.undo_stage_hunk }
  map {
    'n',
    '<leader>gb',
    function()
      gitsigns.blame_line { full = true }
    end,
  }
end