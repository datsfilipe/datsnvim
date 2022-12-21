local ok, tokyonight = pcall(require, 'tokyonight')
if not ok then
  return
end

local theme = vim.g['THEME']
if theme ~= 'tokyonight' then
  return
end

tokyonight.setup {
  transparent = true,
  dim_inactive = false,
  terminal_colors = false,
  lualine_bold = true,
  styles = {
    comments = 'NONE',
    functions = 'NONE',
    keywords = 'NONE',
    strings = 'NONE',
    variables = 'NONE',
    sidebars = 'transparent',
    floats = 'transparent',
  },
  on_highlights = function(hl, c)
    -- remove backgrounds
    hl.Normal = { bg = 'NONE' }
    hl.NormalFloat = { bg = 'NONE' }
    hl.SignColumn = { bg = 'NONE' }
    -- change cmp window highlights
    hl.Pmenu = { bg = 'NONE' }
    hl.CmpBorder = { fg = '#2d2e43', bg = 'NONE' }
    hl.CmpDocBorder = { fg = '#2d2e43', bg = 'NONE' }
    -- change indent blankline highlight
    hl.IndentBlanklineIndent1 = { fg = '#2d2e43' }
    -- change telescope window highlight
    hl.TelescopeResultsBorder = { fg = '#2d2e43', bg = 'NONE' }
    hl.TelescopePromptBorder = { fg = '#2d2e43', bg = 'NONE' }
    hl.TelescopePreviewBorder = { fg = '#2d2e43', bg = 'NONE' }
    -- remove background from diagnostics visual text
    hl.DiagnosticVirtualTextError = { fg = c.red, bg = 'NONE' }
    hl.DiagnosticVirtualTextWarn = { fg = c.yellow, bg = 'NONE' }
    hl.DiagnosticVirtualTextInfo = { fg = c.blue, bg = 'NONE' }
    hl.DiagnosticVirtualTextHint = { fg = c.green, bg = 'NONE' }
  end,
}

vim.cmd [[ colorscheme tokyonight ]]
