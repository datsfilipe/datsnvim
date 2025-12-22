vim.pack.add {
  'https://github.com/catppuccin/nvim',
  'https://github.com/craftzdog/solarized-osaka.nvim',
  'https://github.com/datsfilipe/gruvbox.nvim',
  'https://github.com/datsfilipe/min-theme.nvim',
  'https://github.com/datsfilipe/vesper.nvim',
  'https://github.com/rebelot/kanagawa.nvim',
}

local common_highlights = {
  IndentLine = { fg = '#343434' },
  IndentLineCurrent = { fg = '#343434' },
  NotifyINFOBorder = { fg = '#343434' },
}

local dats_themes = {
  vesper = {},
  gruvbox = { theme = 'dark' },
  ['min-theme'] = { theme = 'dark' },
}

for name, specific_opts in pairs(dats_themes) do
  require(name).setup(vim.tbl_deep_extend('force', {
    transparent = true,
    italics = {
      comments = false,
      keywords = false,
      functions = false,
      strings = false,
      variables = false,
    },
    overrides = common_highlights,
  }, specific_opts))
end

require('solarized-osaka').setup {
  on_highlights = function(hl, _)
    for k, v in pairs(common_highlights) do
      hl[k] = v
    end
  end,
}

require('kanagawa').setup {
  undercurl = true,
  transparent = true,
  theme = 'dragon',
  overrides = function(_)
    return vim.tbl_extend('force', common_highlights, {
      Visual = { bg = '#363646' },
    })
  end,
}

require('catppuccin').setup {
  flavour = 'mocha',
  transparent_background = true,
  dim_inactive = {
    enabled = false,
    shade = 'dark',
    percentage = 0.15,
  },
  custom_highlights = function()
    return common_highlights
  end,
}

for _, group in ipairs {
  'ColorColumn',
  'DiagnosticSignError',
  'DiagnosticSignHint',
  'DiagnosticSignInfo',
  'DiagnosticSignWarn',
  'EndOfBuffer',
  'FloatBorder',
  'FoldColumn',
  'Folded',
  'IndentLine',
  'IndentLineCurrent',
  'LineNr',
  'Normal',
  'NormalFloat',
  'NormalNC',
  'Pmenu',
  'QuickFixLine',
  'SignColumn',
  'StatusLine',
  'StatusLineNC',
  'TabLine',
  'Terminal',
} do
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok then
    hl.bg = nil
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_set_hl(0, group, hl)
  end
end

local theme = vim.g.datsnvim_theme or 'vesper'
vim.cmd.colorscheme(theme)
