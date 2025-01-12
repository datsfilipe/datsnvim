return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  config = function()
    local utils = require 'utils'
    local prettier_and_biome_handler = function()
      if utils.is_file_available '.prettierrc' then
        return { 'prettier', 'prettierd' }
      end
      if utils.is_file_available 'biome.json' then
        return { 'biome' }
      end
      return {}
    end

    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = function()
          if utils.is_bin_available 'alejandra' then
            return { command = 'alejandra', args = { '-qq' } }
          end
          return {}
        end,
        javascript = prettier_and_biome_handler,
        typescript = prettier_and_biome_handler,
        less = { 'prettier', 'prettierd' },
        css = { 'prettier', 'prettierd' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    }
  end,
}
