local ok, comment = pcall(require, 'Comment')
if not ok then
  return
end

local nmap = require('dtsf.keymap').nmap
local vmap = require('dtsf.keymap').vmap

local opts = { noremap = true, silent = true }

comment.setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}

nmap { '<leader>/', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', opts }
vmap { '<leader>/', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts }
