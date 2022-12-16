local ok, saga = pcall(require, 'lspsaga')
if not ok then
  return
end

local nmap = require('dtsf.keymap').nmap
local imap = require('dtsf.keymap').imap

saga.init_lsp_saga {
  server_filetype_map = {
    typescript = 'typescript',
  },
  -- if true can press number to execute the codeaction in codeaction window
  code_action_num_shortcut = true,
  -- same as nvim-lightbulb but async
  code_action_lightbulb = {
    enable = false,
  },
}

local opts = { noremap = true, silent = true }

nmap { 'K', '<cmd>Lspsaga hover_doc<CR>', opts }
nmap { '<C-j>', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts }
nmap { 'gp', '<cmd>Lspsaga peek_definition<CR>', opts }
nmap { 'gr', '<cmd>Lspsaga rename<CR>', opts }
imap { '<C-t>', '<cmd>Lspsaga signature_help<CR>', opts }
