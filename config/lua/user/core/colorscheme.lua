local M = {}

M.highlight_groups = {
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

local function apply(groups)
  local targets = {}
  vim.list_extend(targets, M.highlight_groups)
  if groups then
    vim.list_extend(targets, groups)
  end

  for _, group in ipairs(targets) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok then
      hl.bg = nil
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.api.nvim_set_hl(0, group, hl)
    end
  end
end

function M.apply_transparency(groups)
  apply(groups)
end

local function resolve_theme()
  local theme = vim.env.DATSNVIM_THEME or vim.g.datsnvim_theme or 'vesper'
  vim.g.datsnvim_theme = theme
  return theme
end

function M.setup()
  local theme = resolve_theme()
  pcall(require, 'user.plugins.colorschemes')

  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if not ok then
    vim.notify(
      string.format('failed to load colorscheme %s: %s', theme, err),
      vim.log.levels.WARN
    )
  end
  apply()
end

return M
