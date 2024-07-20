vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'Terminal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'Folded', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'DiagnosticSignError', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { bg = 'none' })

    -- plugins
    vim.api.nvim_set_hl(0, 'CmpBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'CmpDocBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'IndentLineChar', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'TroubleNormal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'GitSignsAdd', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'GitSignsChange', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'GitSignsDelete', { bg = 'none' })
  end,
})