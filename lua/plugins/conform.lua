return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  config = function()
    local utils = require 'utils'
    require('conform').setup {
      formatters = {
        alejandra = {
          command = 'alejandra',
          args = { '-qq' },
          stdin = true,
          condition = function()
            return utils.is_bin_available 'alejandra'
          end,
          inherit = false,
        },
        prettier = {
          command = 'prettier',
          args = {
            '--stdin-filepath',
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
          },
          stdin = true,
          condition = function()
            return utils.is_bin_available 'prettier'
              and utils.is_file_available '.prettierrc'
          end,
          inherit = false,
        },
        biome = {
          command = 'biome',
          args = {
            'format',
            '--stdin-filepath',
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
          },
          stdin = true,
          condition = function()
            return utils.is_bin_available 'biome'
              and utils.is_file_available '.biome'
          end,
          inherit = false,
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'alejandra' },
        javascript = { 'prettier', 'biome', stop_after_first = true },
        typescript = { 'prettier', 'biome', stop_after_first = true },
        less = { 'prettier', 'prettierd', stop_after_first = true },
        css = { 'prettier', 'prettierd', stop_after_first = true },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    }
  end,
}
