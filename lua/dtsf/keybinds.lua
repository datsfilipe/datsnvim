api = vim.api
opt = vim.opt

active = false
function nmap(keys, command)
  api.nvim_set_keymap("n", keys, command .. " <CR>", { noremap = true, silent = true })
end

function vmap(keys, command)
  api.nvim_set_keymap("v", keys, command .. " <CR>", { noremap = true, silent = true })
end

function imap(keys, command)
  api.nvim_set_keymap("i", keys, command, { noremap = true, silent = true })
end

-- Normal Map
nmap("<leader>v", ":vs")
nmap("<leader>h", ":split")
nmap("<leader>t", ":tabnew")
nmap("<leader>x", ":tabclose")

nmap("<leader>s", ":w")
nmap("<leader>q", ":q")
nmap("<ESC>", ":nohlsearch")

-- Truezen toggle
nmap("<leader>m", ":TZAtaraxis")

-- Telescope
nmap("<leader><space>", ":Telescope")
nmap("ff", ":Telescope find_files")
nmap("fb", ":Telescope buffers")

-- File browsing
nmap("<C-E>", ":Explore")

-- Comment
nmap("<leader>/", ":lua require('Comment.api').toggle_current_linewise()")

-- Visual Map
vmap("<leader>/", ":lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())")

-- Insert Map
imap("<C-D>" , "<End>")
imap("<C-A>" , "<Home>")
