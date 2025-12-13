local theme = vim.g.datsnvim_theme or 'vesper'
local static_color = require('user.utils').static_color

local function apply(groups)
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

return {
  setup = function()
    local ok, mod = pcall(require, 'user.plugins.colorschemes.' .. theme)
    if ok and mod.setup then
      mod.setup()
      vim.cmd.colorscheme(theme)
    end
  end,
  
  apply_transparency = function(groups)
    apply(groups)
  end
}
