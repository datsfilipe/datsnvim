local config = require 'utils.config'

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = ' '
    else
      vim.o.laststatus = 0
    end
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = config.colorscheme,
      icons_enabled = true,
      globalstatus = true,
      disabled_filetypes = { 'NeogitStatus' },
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
          cond = function()
            return package.loaded['noice']
              and require('noice').api.status.command.has()
          end,
        },
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
        {
          'diff',
          symbols = {
            added = config.diff.added,
            modified = config.diff.modified,
            removed = config.diff.removed,
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
        'branch',
      },
    },
    tabline = {},
    extensions = {},
  },
}
