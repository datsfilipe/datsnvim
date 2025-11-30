local M = {}

function M.setup()
  if M._loaded then
    return
  end
  M._loaded = true

  local utils = require 'user.utils'

  local ok, conform = pcall(require, 'conform')
  if not ok then
    return
  end

  conform.setup {
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
          '$FILENAME',
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
          '$FILENAME',
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
      javascript = {
        { 'prettierd', 'prettier', 'biome' },
        'eslint',
      },
      typescript = {
        { 'prettierd', 'prettier', 'biome' },
        'eslint',
      },
      javascriptreact = {
        { 'prettierd', 'prettier', 'biome' },
        'eslint',
      },
      typescriptreact = {
        { 'prettierd', 'prettier', 'biome' },
        'eslint',
      },
      less = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
    },
    format_on_save = function(bufnr)
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match 'oil://' then
        return
      end

      return {
        timeout_ms = 1000,
        lsp_format = 'fallback',
      }
    end,
  }
end

return M
