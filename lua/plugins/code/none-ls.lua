local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

local async_formatting = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  vim.lsp.buf_request(
    bufnr,
    'textDocument/formatting',
    vim.lsp.util.make_formatting_params {},
    function(err, res, ctx)
      if err then
        local err_msg = type(err) == 'string' and err or err.message
        vim.notify('formatting: ' .. err_msg, vim.log.levels.WARN)
        return
      end

      if
        not vim.api.nvim_buf_is_loaded(bufnr)
        or vim.api.nvim_buf_get_option(bufnr, 'modified')
      then
        return
      end

      if res then
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        vim.lsp.util.apply_text_edits(
          res,
          bufnr,
          client and client.offset_encoding or 'utf-16'
        )
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd 'silent noautocmd update'
        end)
      end
    end
  )
end

return {
  'nvimtools/none-ls.nvim',
  event = 'BufReadPre',
  opts = function()
    return {
      debug = false,
      sources = {
        require('null-ls').builtins.formatting.stylua,

        require('null-ls').builtins.formatting.prettier.with {
          condition = function(utils)
            return utils.root_has_file {
              '.prettierrc',
              '.prettierrc.json',
              '.prettierrc.yaml',
              '.prettierrc.yml',
              '.prettierrc.js',
              'prettier.config.js',
            }
          end,
        },
        require('null-ls').builtins.formatting.biome.with {
          condition = function(utils)
            return utils.root_has_file { 'biome.toml' }
          end,
        },

        require('null-ls').builtins.diagnostics.codespell,
        require('null-ls').builtins.diagnostics.editorconfig_checker.with {
          condition = function(utils)
            return utils.root_has_file { '.editorconfig' }
          end,
        },
      },
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePost', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              async_formatting(bufnr)
            end,
          })
        end
      end,
    }
  end,
}
