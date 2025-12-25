vim.pack.add {
  'https://github.com/datsfilipe/datscolorscheme.nvim',
}

local dats = require 'dats'

dats.setup {
  themes = {
    gruvbox = {
      bg = '#1d2021',
      fg = '#ebdbb2',
      line_bg = '#3c3836',
      float_bg = '#504945',
      dim = '#928374',
      keyword = '#fb4934',
      definition = '#83a598',
      call = '#fabd2f',
      value = '#b8bb26',
      variable = '#ebdbb2',
      param = '#d3869b',
      error = '#fb4934',
      selection_bg = '#504945',
      search_bg = '#fabd2f',
      search_fg = '#1d2021',
      match_bg = '#fe8019',
      match_fg = '#1d2021',
    },

    vesper = {
      bg = '#101010',
      fg = '#E6E6E6',
      line_bg = '#161616',
      float_bg = '#282828',
      dim = '#65737E',
      keyword = '#A0A0A0',
      definition = '#FFCFA8',
      call = '#FFC799',
      value = '#99FFE4',
      variable = '#E6E6E6',
      param = '#A0A0A0',
      error = '#FF8080',
      selection_bg = '#343434',
      search_bg = '#FFC799',
      search_fg = '#101010',
      match_bg = '#FFCFA8',
      match_fg = '#101010',
    },

    min = {
      bg = '#212121',
      fg = '#c1c1c1',
      line_bg = '#292929',
      float_bg = '#383838',
      dim = '#6b737c',
      keyword = '#ff7a84',
      definition = '#b392f0',
      call = '#79b8ff',
      value = '#ffab70',
      variable = '#c1c1c1',
      param = '#b392f0',
      error = '#cd3131',
      selection_bg = '#444444',
      search_bg = '#cd9731',
      search_fg = '#212121',
      match_bg = '#cd9731',
      match_fg = '#212121',
    },

    solarized = {
      bg = '#002b36',
      fg = '#839496',
      line_bg = '#073642',
      float_bg = '#073642',
      dim = '#586e75',
      keyword = '#859900',
      definition = '#268bd2',
      call = '#b58900',
      value = '#2aa198',
      variable = '#839496',
      param = '#dc322f',
      error = '#dc322f',
      selection_bg = '#073642',
      search_bg = '#b58900',
      search_fg = '#002b36',
      match_bg = '#cb4b16',
      match_fg = '#fdf6e3',
    },

    ['catppuccin'] = {
      bg = '#1e1e2e',
      fg = '#cdd6f4',
      line_bg = '#181825',
      float_bg = '#181825',
      dim = '#6c7086',
      keyword = '#cba6f7',
      definition = '#89b4fa',
      call = '#f9e2af',
      value = '#a6e3a1',
      variable = '#cdd6f4',
      param = '#f5c2e7',
      error = '#f38ba8',
      selection_bg = '#45475a',
      search_bg = '#f9e2af',
      search_fg = '#1e1e2e',
      match_bg = '#fab387',
      match_fg = '#1e1e2e',
    },
  },
}

local theme_name = vim.g.datsnvim_theme or 'vesper'
dats.load_theme(theme_name)

for _, group in ipairs {
  'ColorColumn',
  'LineNr',
  'Normal',
  'NormalNC',
  'Pmenu',
  'SignColumn',
  'StatusLine',
  'StatusLineNC',
} do
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok then
    hl.bg = nil
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_set_hl(0, group, hl)
  end
end

for _, group in ipairs {
  'DiagnosticUnderlineError',
  'DiagnosticUnderlineWarn',
  'DiagnosticUnderlineInfo',
  'DiagnosticUnderlineHint',
} do
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok then
    hl.undercurl = true
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_set_hl(0, group, hl)
  end
end
