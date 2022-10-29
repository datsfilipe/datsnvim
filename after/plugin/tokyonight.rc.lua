local present, tokyonight = pcall(require, 'tokyonight')
if not present then
  return
end

tokyonight.setup({
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
    floats = 'transparent'
  },
  on_highlights = function(hl, c)
    hl.LspDiagnosticsDefaultHint = { fg = c.blue }
    hl.LspDiagnosticsDefaultInformation = { fg = c.blue }
    hl.LspDiagnosticsDefaultWarning = { fg = c.yellow }
    hl.LspDiagnosticsDefaultError = { fg = c.red }
    -- remove telescope background
    hl.TelescopeNormal = { bg = 'NONE' }
    hl.TelescopeBorder = { bg = 'NONE' }
    hl.TelescopePromptBorder = { bg = 'NONE' }
    hl.TelescopeResultsBorder = { bg = 'NONE' }
    hl.TelescopePreviewBorder = { bg = 'NONE' }
  end,
})

vim.cmd[[colorscheme tokyonight-storm]]
-- change highlight color for indent blankline
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#2d2e43 gui=NONE]]
-- change highlight colors for telescope
vim.cmd [[highlight TelescopePromptBorder guifg=#2d2e43 gui=NONE]]
vim.cmd [[highlight TelescopePreviewBorder guifg=#2d2e43 gui=NONE]]
vim.cmd [[highlight TelescopeResultsBorder guifg=#2d2e43 gui=NONE]]
-- change cmp border color
vim.cmd [[highlight CmpBorder guifg=#2d2e43]]
vim.cmd [[highlight CmpDocBorder guifg=#2d2e43]]
-- change highlight for float window background
vim.cmd [[highlight NormalFloat guibg=NONE]]
