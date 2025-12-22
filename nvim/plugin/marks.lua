---@diagnostic disable: param-type-mismatch
vim.keymap.set('n', 'dm', function()
  local char = vim.fn.nr2char(vim.fn.getchar())
  if char == '\27' then
    return
  end

  pcall(vim.cmd, 'delmarks ' .. char)
end, { noremap = true, silent = true })
