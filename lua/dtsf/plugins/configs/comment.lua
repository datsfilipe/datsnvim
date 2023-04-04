local ok, comment = pcall(require, 'Comment')
if not ok then
  return
end

local nmap = require('dtsf.utils').nmap
local vmap = require('dtsf.utils').vmap

local opts = { noremap = true, silent = true }

comment.setup {}

nmap { '<leader>/', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', opts }
vmap { '<leader>/', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts }
