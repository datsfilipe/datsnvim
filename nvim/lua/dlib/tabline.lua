_G.tabline = function()
  local parts = {}
  local curr_tab = vim.fn.tabpagenr()

  for i = 1, vim.fn.tabpagenr('$') do
    local win_idx = vim.fn.tabpagewinnr(i)
    local buf_id = vim.fn.tabpagebuflist(i)[win_idx]
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf_id), ':t')
    
    local hl = (i == curr_tab) and '%#TabLineSel#' or '%#TabLine#'
    
    table.insert(parts, hl .. '%' .. i .. 'T ' .. (name ~= '' and name or '[No Name]') .. ' ')
  end

  return table.concat(parts) .. '%#TabLineFill#%T'
end

vim.o.tabline = '%!v:lua.tabline()'
