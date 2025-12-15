local theme = vim.g.datsnvim_theme or 'vesper'

require('user.plugins.colorschemes.' .. theme)

local targets = {
  'Normal',
  'NormalNC',
  'NormalFloat',
  'FloatBorder',
  'Pmenu',
  'Terminal',
  'EndOfBuffer',
  'FoldColumn',
  'Folded',
  'ColorColumn',
  'SignColumn',
  'LineNr',
  'DiagnosticSignWarn',
  'DiagnosticSignError',
  'DiagnosticSignHint',
  'DiagnosticSignInfo',
  'IndentLine',
  'IndentLineCurrent',
  'TabLine',
  'QuickFixLine',
  'StatusLine',
  'StatusLineNC',
}

for _, group in ipairs(targets) do
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok then
    hl.bg = nil
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_set_hl(0, group, hl)
  end
end

vim.cmd.colorscheme(theme)
