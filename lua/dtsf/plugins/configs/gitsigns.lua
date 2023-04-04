local present, gitsigns = pcall(require, 'gitsigns')
if not present then
  return
end

local nmap = require('dtsf.utils').nmap
local vmap = require('dtsf.utils').vmap

gitsigns.setup {
  on_attach = function()
    nmap { '<leader>gs', ':Gitsigns stage_hunk<CR>' }
    nmap { '<leader>gr', ':Gitsigns reset_hunk<CR>' }
    vmap { '<leader>gs', ':Gitsigns stage_hunk<CR>' }
    vmap { '<leader>gr', ':Gitsigns reset_hunk<CR>' }
    nmap { '<leader>gu', gitsigns.undo_stage_hunk }
    nmap {
      '<leader>gb',
      function()
        gitsigns.blame_line { full = true }
      end,
    }
  end,
}
