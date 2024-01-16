local config = require 'utils/config'

local commonHighlights = {
  NormalFloat = { bg = 'NONE' },
  CmpBorder = { fg = config.indent_color, bg = 'NONE' },
  CmpDocBorder = { fg = config.indent_color, bg = 'NONE' },
  IndentLineChar = { fg = config.indent_color, bg = 'NONE' },
  TelescopeBorder = { fg = config.indent_color, bg = 'NONE' },
  NotifyINFOBorder = { fg = config.indent_color, bg = 'NONE' },
}

return {
  {
    'datsfilipe/min-theme.nvim',
    lazy = false,
    priority = 1000,
    enabled = config.colorscheme == 'min-theme',
    opts = {
      theme = 'dark',
      transparent = true,
      italics = {
        comments = false,
        keywords = false,
        functions = false,
        strings = false,
        variables = false,
      },
      overrides = vim.tbl_extend('force', commonHighlights, {}),
    },
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    enabled = config.colorscheme == 'gruvbox',
    opts = {
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        operators = false,
        comments = false,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = 'hard',
      palette_overrides = {},
      dim_inactive = false,
      transparent_mode = true,
      overrides = vim.tbl_extend('force', commonHighlights, {
        TelescopePromptBorder = { fg = config.indent_color, bg = 'NONE' },
        TelescopeResultsBorder = { fg = config.indent_color, bg = 'NONE' },
        TelescopePreviewBorder = { fg = config.indent_color, bg = 'NONE' },
      }),
    },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    enabled = config.colorscheme == 'catppuccin',
    opts = {
      flavour = 'mocha',
      dim_inactive = {
        enabled = false,
        shade = 'dark',
        percentage = 0.15,
      },
      transparent_background = true,
      custom_highlights = function()
        return vim.tbl_extend('force', commonHighlights, {})
      end,
    },
  },
  {
    'craftzdog/solarized-osaka.nvim',
    enabled = config.colorscheme == 'solarized-osaka',
    lazy = false,
    priority = 1000,
    opts = {
      on_highlights = function(hl, _)
        for k, v in pairs(commonHighlights) do
          hl[k] = v
        end
        hl['TelescopeNormal'] = { bg = 'NONE' }
        hl['TroubleNormal'] = { bg = 'NONE' }
      end,
    },
  },
  {
    'rebelot/kanagawa.nvim',
    enabled = config.colorscheme == 'kanagawa',
    lazy = false,
    priority = 1000,
    opts = {
      undercurl = true,
      transparent = true,
      overrides = function(_)
        local newHighlights = {}

        for k, v in pairs(commonHighlights) do
          newHighlights[k] = v
        end

        newHighlights['Visual'] = { bg = '#363646' }
        newHighlights['LineNr'] = { bg = 'NONE' }
        newHighlights['SignColumn'] = { bg = 'NONE' }
        newHighlights['GitSignsAdd'] = { bg = 'NONE' }
        newHighlights['GitSignsChange'] = { bg = 'NONE' }
        newHighlights['GitSignsDelete'] = { bg = 'NONE' }
        newHighlights['DiagnosticSignWarn'] = { bg = 'NONE' }
        newHighlights['DiagnosticSignError'] = { bg = 'NONE' }
        newHighlights['DiagnosticSignHint'] = { bg = 'NONE' }
        newHighlights['DiagnosticSignInfo'] = { bg = 'NONE' }

        return vim.tbl_extend('force', newHighlights, {})
      end,
      theme = "dragon",
    },
  },
}
