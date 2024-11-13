local function feedkeys(keys)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(keys, true, false, true),
    'n',
    true
  )
end

local function pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

vim.keymap.set('i', '<cr>', function()
  return pumvisible() and '<C-y>' or '<cr>'
end, { expr = true })

vim.keymap.set('i', '<C-e>', function()
  return pumvisible() and '<C-e>' or '<C-e>'
end, { expr = true })

vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if pumvisible() then
    feedkeys '<C-n>'
  elseif vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  else
    feedkeys '<Tab>'
  end
end, {})

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if pumvisible() then
    feedkeys '<C-p>'
  elseif vim.snippet.active { direction = -1 } then
    vim.snippet.jump(-1)
  else
    feedkeys '<S-Tab>'
  end
end, {})
