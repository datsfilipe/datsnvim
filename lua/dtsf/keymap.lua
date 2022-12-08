local M = {}

M.imap = function(table)
  vim.keymap.set('i', table[1], table[2], table[3])
end

M.vmap = function(table)
  vim.keymap.set('v', table[1], table[2], table[3])
end

M.nmap = function(table)
  vim.keymap.set('n', table[1], table[2], table[3])
end

return M
