local M = {}

local script_dir = os.getenv 'HOME' .. '/.config/nvim/scripts/'

function M.patch_mason_binaries(pkg)
  if require('utils.os').is_nixos() == false then
    return
  end

  pkg:get_receipt():if_present(function(receipt)
    for _, rel_path in pairs(receipt.links.bin) do
      local bin_abs_path = pkg:get_install_path() .. '/' .. rel_path
      if pkg.name == 'lua-language-server' then
        bin_abs_path = pkg:get_install_path()
          .. '/libexec/bin/lua-language-server'
      end

      os.execute(script_dir .. 'nixos_patch_mason.sh ' .. bin_abs_path)
    end
  end)
end

M.augroup = vim.api.nvim_create_augroup('LspFormatting', {})

M.formatter = function(client, bufnr)
  if
    client.supports_method 'textDocument/formatting'
    or client.supports_method 'textDocument/rangeFormatting'
  then
    vim.api.nvim_clear_autocmds { group = M.augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = M.augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format {
          filter = function()
            return client.name == 'null-ls'
          end,
          bufnr = bufnr,
        }
      end,
    })
  end
end

M.on_attach = function(client, buffer, opts)
  if opts.codelens.enabled and vim.lsp.codelens then
    if client.supports_method 'textDocument/codeLens' then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        buffer = buffer,
        callback = vim.lsp.codelens.refresh,
      })
    end
  end

  M.formatter(client, buffer)
end

return M
