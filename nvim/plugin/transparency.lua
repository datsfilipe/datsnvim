vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    local groups = {
      'Normal',
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
    }

    for _, group in ipairs(groups) do
      local hl = vim.api.nvim_get_hl(0, { name = group })
      hl.bg = nil
      vim.api.nvim_set_hl(0, group, hl)
    end
  end,
})
