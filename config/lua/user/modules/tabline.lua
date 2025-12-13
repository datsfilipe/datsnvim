local function render()
  local t = {}
  local cur = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr '$'
  for i = 1, total do
    t[#t + 1] = (i == cur) and '%#TabLineSel#' or '%#TabLine#'
    t[#t + 1] = '%' .. i .. 'T'
    local buflist = vim.fn.tabpagebuflist(i)
    local winnr = vim.fn.tabpagewinnr(i)
    local name = vim.fn.fnamemodify(vim.fn.bufname(buflist[winnr]), ':t')
    t[#t + 1] = ' ' .. (name ~= '' and name or '[No Name]') .. ' '
  end
  t[#t + 1] = '%#TabLineFill#%T'
  return table.concat(t)
end

return {
  setup = function()
    _G.tabline_render = render
    vim.o.tabline = '%!v:lua.tabline_render()'
  end,
}
