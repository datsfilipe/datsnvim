local M = {}

local function is_oil_buffer(bufnr)
  bufnr = bufnr or 0
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  local ft = vim.bo[bufnr].filetype
  local bt = vim.bo[bufnr].buftype
  return (name ~= '' and name:match '^oil://') or ft == 'oil' or bt == 'oil'
end

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
      },
      prettier = {
        command = 'prettier',
        condition = function(_, ctx)
          if is_oil_buffer(ctx.buf) then
            return false
          end
          local filename = ctx.filename
          if not filename or filename == '' or filename:match '^oil://' then
            return false
          end
          return utils.is_bin_available 'prettier'
            and utils.is_file_available '.prettierrc'
            and vim.loop.fs_stat(filename)
        end,
      },
      biome = {
        command = 'biome',
        args = { 'format', '--stdin-filepath', '$FILENAME' },
        stdin = true,
        condition = function(_, ctx)
          if is_oil_buffer(ctx.buf) then
            return false
          end
          local filename = ctx.filename
          if not filename or filename == '' or filename:match '^oil://' then
            return false
          end
          return utils.is_bin_available 'biome'
            and utils.is_file_available '.biome'
            and vim.loop.fs_stat(filename)
        end,
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
    format_on_save = function(bufnr)
      if is_oil_buffer(bufnr) then
        return
      end
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end,
  }
end

return M
