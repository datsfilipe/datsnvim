local utils = require 'user.utils'

local codespell_ns = vim.api.nvim_create_namespace 'user/codespell'

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

local candidates = {
  nix = {
    { bin = 'alejandra', args = { '--quiet', '-' } },
  },
  lua = {
    { bin = 'stylua', args = { '-' } },
  },
  javascript = {
    {
      bin = 'prettierd',
      args = { '$FILENAME' },
      configs = {
        '.prettierrc',
        '.prettierrc.json',
        '.prettierrc.js',
        'prettier.config.js',
      },
    },
    {
      bin = 'prettier',
      args = { '--stdin-filepath', '$FILENAME' },
      configs = {
        '.prettierrc',
        '.prettierrc.json',
        '.prettierrc.js',
        'prettier.config.js',
      },
    },
    {
      bin = 'biome',
      args = { 'format', '--stdin-filepath', '$FILENAME' },
      configs = { 'biome.json', 'biome.jsonc' },
    },
  },
  typescript = 'javascript',
  javascriptreact = 'javascript',
  typescriptreact = 'javascript',
  json = 'javascript',
  css = 'javascript',
  html = 'javascript',
}

return {
  setup = function()
    local function resolve_formatter(ft)
      local options = candidates[ft]

      while type(options) == 'string' do
        options = candidates[options]
      end

      if not options then
        return nil
      end

      for _, tool in ipairs(options) do
        if utils.is_bin_available(tool.bin) then
          local config_found = true
          if tool.configs then
            config_found = false
            for _, config_file in ipairs(tool.configs) do
              if utils.is_file_available(config_file) then
                config_found = true
                break
              end
            end
          end

          if config_found then
            return tool
          end
        end
      end
      return nil
    end

    ---@return boolean true if a cli formatter was found and run
    local function run_cli_formatter(bufnr)
      if is_oil_buffer(bufnr) then
        return false
      end

      local ft = vim.bo[bufnr].filetype
      local tool = resolve_formatter(ft)
      if not tool then
        return false
      end

      local filename = vim.api.nvim_buf_get_name(bufnr)
      local cmd = { tool.bin }

      for _, arg in ipairs(tool.args) do
        if arg == '$FILENAME' then
          table.insert(cmd, filename)
        else
          table.insert(cmd, arg)
        end
      end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local content = table.concat(lines, '\n')

      local result = vim.system(cmd, { stdin = content }):wait()

      if result.code == 0 and result.stdout then
        local new_lines = vim.split(result.stdout, '\n')
        if new_lines[#new_lines] == '' then
          table.remove(new_lines)
        end

        if table.concat(new_lines, '\n') ~= content then
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
        end
      elseif result.code ~= 0 then
        vim.notify(
          'format error (' .. tool.bin .. '): ' .. (result.stderr or ''),
          vim.log.levels.WARN
        )
      end

      return true
    end

    local function run_codespell_diagnostics(bufnr)
      if is_oil_buffer(bufnr) then
        return
      end

      if not utils.is_bin_available 'codespell' then
        return
      end

      local filename = vim.api.nvim_buf_get_name(bufnr)
      if filename == '' then
        return
      end

      vim.system({ 'codespell', filename }, {}, function(out)
        local diagnostics = {}
        if out.stdout and out.stdout ~= '' then
          for _, line in ipairs(vim.split(out.stdout, '\n')) do
            local lnum, typo, suggestion =
              line:match '^.+:(%d+):%s+(.*)%s+==>%s+(.*)'

            if lnum then
              table.insert(diagnostics, {
                bufnr = bufnr,
                lnum = tonumber(lnum) - 1,
                col = 0,
                message = string.format("'%s' -> '%s'", typo, suggestion),
                severity = vim.diagnostic.severity.WARN,
                source = 'codespell',
              })
            end
          end
        end

        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.diagnostic.set(codespell_ns, bufnr, diagnostics)
          end
        end)
      end)
    end

    local format_group =
      vim.api.nvim_create_augroup('NativeFormatChain', { clear = true })
    local diag_group =
      vim.api.nvim_create_augroup('NativeDiagChain', { clear = true })

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = format_group,
      callback = function(ev)
        if is_oil_buffer(ev.buf) then
          return
        end

        local cli_handled = run_cli_formatter(ev.buf)
        if not cli_handled then
          local clients = vim.lsp.get_clients { bufnr = ev.buf }
          for _, client in ipairs(clients) do
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            if client.supports_method 'textDocument/formatting' then
              vim.lsp.buf.format { bufnr = ev.buf, async = false }
              break
            end
          end
        end
      end,
    })

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
      group = diag_group,
      callback = function(ev)
        run_codespell_diagnostics(ev.buf)
      end,
    })
  end,
}
