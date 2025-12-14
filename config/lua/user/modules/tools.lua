local utils = require 'user.utils'
local cspell_ns = vim.api.nvim_create_namespace 'user/cspell'

local insert = table.insert
local concat = table.concat

local function is_oil_buffer(bufnr)
  bufnr = bufnr or 0
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  return (name ~= '' and name:match '^oil://')
    or vim.bo[bufnr].filetype == 'oil'
end

local candidates = {
  nix = { { bin = 'alejandra', args = { '--quiet', '-' } } },
  lua = { { bin = 'stylua', args = { '-' } } },
  javascript = {
    {
      bin = 'prettierd',
      args = { '$FILENAME' },
      configs = { '.prettierrc', '.prettierrc.json', 'prettier.config.js' },
    },
    {
      bin = 'biome',
      args = { 'format', '--stdin-filepath', '$FILENAME' },
      configs = { 'biome.json' },
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
          local ok = not tool.configs
          if tool.configs then
            for _, cfg in ipairs(tool.configs) do
              if utils.is_file_available(cfg) then
                ok = true
                break
              end
            end
          end
          if ok then
            return tool
          end
        end
      end
      return nil
    end

    local function run_cli_formatter(bufnr)
      if is_oil_buffer(bufnr) then
        return false
      end
      local tool = resolve_formatter(vim.bo[bufnr].filetype)
      if not tool then
        return false
      end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local content = concat(lines, '\n')
      local cmd = { tool.bin }
      for _, arg in ipairs(tool.args) do
        insert(
          cmd,
          arg == '$FILENAME' and vim.api.nvim_buf_get_name(bufnr) or arg
        )
      end

      vim.system(cmd, { stdin = content }, function(out)
        if out.code == 0 and out.stdout and out.stdout ~= '' then
          local new_lines = vim.split(out.stdout, '\n')
          if new_lines[#new_lines] == '' then
            table.remove(new_lines)
          end
          vim.schedule(function()
            if
              vim.api.nvim_buf_is_valid(bufnr)
              and concat(new_lines, '\n') ~= content
            then
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
            end
          end)
        end
      end)
      return true
    end

    local function run_cspell_diagnostics(bufnr)
      if is_oil_buffer(bufnr) or not utils.is_bin_available 'cspell' then
        return
      end
      local filename = vim.api.nvim_buf_get_name(bufnr)
      if filename == '' then
        return
      end

      local cmd = {
        'cspell',
        'lint',
        '--no-progress',
        '--no-summary',
        '--language-id',
        vim.bo[bufnr].filetype,
        filename,
      }

      local root = vim.fs.find(
        { '.vscode' },
        { upward = true, path = vim.fs.dirname(filename) }
      )[1]
      if root then
        local f = io.open(root .. '/settings.json', 'r')
        if f then
          local c = f:read '*a'
          f:close()
          local words = c:match '"cspell.words":%s*%[([^%]]+)%]'
          if words then
            for w in words:gmatch '"([^"]+)"' do
              insert(cmd, '--words-list')
              insert(cmd, w)
            end
          end
        end
      end

      vim.system(cmd, {}, function(out)
        local diagnostics = {}
        if out.stdout and out.stdout ~= '' then
          for _, line in ipairs(vim.split(out.stdout, '\n')) do
            local lnum, col, msg = line:match ':(%d+):(%d+)%s%-%s(.*)'
            if lnum then
              insert(diagnostics, {
                bufnr = bufnr,
                lnum = tonumber(lnum) - 1,
                col = tonumber(col) - 1,
                message = msg,
                severity = vim.diagnostic.severity.HINT,
                source = 'cspell',
              })
            end
          end
        end
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.diagnostic.set(cspell_ns, bufnr, diagnostics)
          end
        end)
      end)
    end

    local group = vim.api.nvim_create_augroup('ToolsChain', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = group,
      callback = function(ev)
        if not run_cli_formatter(ev.buf) then
          local clients = vim.lsp.get_clients { bufnr = ev.buf }
          for _, client in ipairs(clients) do
            ---@diagnostic disable-next-line: param-type-mismatch
            if client.supports_method 'textDocument/formatting' then
              vim.lsp.buf.format { bufnr = ev.buf, async = false }
              break
            end
          end
        end
      end,
    })

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
      group = group,
      callback = function(ev)
        run_cspell_diagnostics(ev.buf)
      end,
    })
  end,
}
