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
        condition = function(ctx)
          local bufnr = ctx.bufnr or 0
          local filename = ctx.filename or vim.api.nvim_buf_get_name(bufnr)
          return utils.is_bin_available 'alejandra'
            and utils.is_real_file(filename)
        end,
        inherit = false,
      },
      prettier = {
        command = 'prettier',
        args = function(ctx)
          local bufnr = ctx.bufnr or 0
          local filename = ctx.filename or vim.api.nvim_buf_get_name(bufnr)
          return { '--stdin-filepath', filename }
        end,
        stdin = true,
        condition = function(ctx)
          local bufnr = ctx.bufnr or 0
          local filename = ctx.filename or vim.api.nvim_buf_get_name(bufnr)
          return utils.is_bin_available 'prettier'
            and utils.is_file_available '.prettierrc'
            and utils.is_real_file(filename)
        end,
        inherit = false,
      },
      biome = {
        command = 'biome',
        args = function(ctx)
          local bufnr = ctx.bufnr or 0
          local filename = ctx.filename or vim.api.nvim_buf_get_name(bufnr)
          return { 'format', '--stdin-filepath', filename }
        end,
        stdin = true,
        condition = function(ctx)
          local bufnr = ctx.bufnr or 0
          local filename = ctx.filename or vim.api.nvim_buf_get_name(bufnr)
          return utils.is_bin_available 'biome'
            and utils.is_file_available '.biome'
            and utils.is_real_file(filename)
        end,
        inherit = false,
      },
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      nix = { 'alejandra' },
      javascript = {
        'prettierd',
        'prettier',
        'biome',
        stop_after_first = true,
      },
      typescript = {
        'prettierd',
        'prettier',
        'biome',
        stop_after_first = true,
      },
      javascriptreact = {
        'prettierd',
        'prettier',
        'biome',
        stop_after_first = true,
      },
      typescriptreact = {
        'prettierd',
        'prettier',
        'biome',
        stop_after_first = true,
      },
      less = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
  }
end

return M
