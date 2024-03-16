local config = require 'utils/config'

return {
  'nvim-lualine/lualine.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = true,
      colorscheme = config.colorscheme,
      component_separators = { left = '|', right = '|' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = {
        'mode',
        {
          function()
            local cmd = require('noice').api.status.command.get()
            if cmd:sub(1, 1) == 'q' then
              if cmd:sub(2) == '' then
                return 'end'
              end

              return 'rec ' .. cmd:sub(2)
            end
            return cmd
          end,
          cond = function() return package.loaded['noice'] and require('noice').api.status.command.has() end,
        }
      },
      lualine_b = {
        {
          'filename',
          file_status = true,
          path = 1,
        },
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        {
          'diagnostics',
          symbols = {
            error = config.signs.Error .. ' ',
            warn = config.signs.Warn .. ' ',
            info = config.signs.Info .. ' ',
            hint = config.signs.Hint .. ' ',
          },
        },
        'progress',
      },
      lualine_z = {
        'branch',
        'diff',
      },
    },
    tabline = {},
    extensions = {},
  },
}
