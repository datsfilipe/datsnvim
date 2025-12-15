local utils = require 'user.utils'
local map = utils.map

local diagnostic_icons = require('user.icons').diagnostics
local methods = vim.lsp.protocol.Methods

local servers = {
  { name = 'lua_ls', bin = 'lua-language-server' },
  {
    name = 'ts_ls',
    bin = 'typescript-language-server',
    config = {
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
      },
      init_options = {
        hostInfo = 'neovim',
        preferences = {
          includeCompletionsForImportStatements = true,
          includeCompletionsWithInsertText = true,
          includeCompletionsForModuleExports = true,
        },
      },
    },
  },
  {
    name = 'eslint',
    bin = 'vscode-eslint-language-server',
    config = { lint = true },
  },
  {
    name = 'cssls',
    bin = 'vscode-css-language-server',
    config = { init_options = { provideFormatter = false } },
  },
  { name = 'biome', bin = 'biome', cmd = { 'biome', 'lsp-proxy' } },
  {
    name = 'bashls',
    bin = 'bash-language-server',
    config = { init_options = { enableBashDebug = true } },
  },
  {
    name = 'jsonls',
    bin = 'vscode-json-language-server',
    config = { init_options = { provideFormatter = true } },
  },
  { name = 'solidity_ls', bin = 'vscode-solidity-server' },
  {
    name = 'rust_analyzer',
    bin = 'rust-analyzer',
    config = { ['rust-analyzer'] = { inlayHints = { enable = false } } },
  },
  {
    name = 'gopls',
    bin = 'gopls',
    config = { filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' } },
  },
  { name = 'nil_ls', bin = 'nil' },
}

local function on_attach(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil

  if client.name == 'ts_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  local function keymap(lhs, rhs, desc)
    map(
      'n',
      lhs,
      rhs,
      { buffer = bufnr, desc = desc, noremap = true, silent = true }
    )
  end

  keymap('ge', vim.diagnostic.setqflist, 'list diagnostics')
  keymap('gE', vim.diagnostic.open_float, 'show diagnostic under cursor')

  if client:supports_method(methods.textDocument_definition) then
    keymap('gd', vim.lsp.buf.definition, 'peek definition')
  end
  if client:supports_method(methods.textDocument_typeDefinition) then
    keymap('gt', vim.lsp.buf.type_definition, 'peek type definition')
  end

  if client:supports_method(methods.textDocument_documentHighlight) then
    local group = vim.api.nvim_create_augroup(
      'cursor_highlights_' .. bufnr,
      { clear = true }
    )
    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local function configure_diagnostics()
  for severity, icon in pairs(diagnostic_icons) do
    local hl = 'DiagnosticSign' .. severity:sub(1, 1) .. severity:sub(2):lower()
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
  end

  vim.diagnostic.config {
    virtual_text = {
      prefix = '',
      spacing = 2,
      format = function(diagnostic)
        local icon =
          diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
        local source = diagnostic.source or ''
        if source == 'Lua Diagnostics.' or source == 'Lua Syntax Check.' then
          source = 'lua'
        end
        local message = string.format('%s %s', icon, source)
        if diagnostic.code then
          message = string.format('%s[%s]', message, diagnostic.code)
        end
        return message .. ' '
      end,
    },
    float = {
      border = 'none',
      source = 'if_many',
      prefix = function(diag)
        local level = vim.diagnostic.severity[diag.severity]
        return string.format(' %s ', diagnostic_icons[level]),
          'Diagnostic' .. level:gsub('^%l', string.upper)
      end,
    },
    signs = false,
  }

  local vt_handler = vim.diagnostic.handlers.virtual_text
  local show_handler = vt_handler.show
  vt_handler.show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(a, b)
      return a.severity > b.severity
    end)
    show_handler(ns, bufnr, diagnostics, opts)
  end
end

local function wrap_handlers()
  local orig_hover = vim.lsp.buf.hover
  vim.lsp.buf.hover = function()
    orig_hover {
      border = 'none',
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    }
  end

  local orig_sig = vim.lsp.buf.signature_help
  vim.lsp.buf.signature_help = function()
    orig_sig {
      border = 'none',
      focusable = false,
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    }
  end

  local register_capability =
    vim.lsp.handlers[methods.client_registerCapability]
  vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      on_attach(client, vim.api.nvim_get_current_buf())
    end
    return register_capability(err, res, ctx)
  end
end

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local ok, _ = pcall(require, 'lspconfig')
    if not ok then
      return
    end

    configure_diagnostics()
    wrap_handlers()

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          on_attach(client, args.buf)
        end
      end,
    })

    local to_enable = {}
    for _, srv in ipairs(servers) do
      if utils.is_bin_available(srv.bin) then
        local cfg = srv.config or {}

        if srv.cmd then
          cfg.cmd = srv.cmd
        elseif srv.bin:match '^vscode%-' then
          cfg.cmd = { srv.bin, '--stdio' }
        end

        vim.lsp.config[srv.name] = cfg
        table.insert(to_enable, srv.name)
      end
    end

    if #to_enable > 0 then
      vim.lsp.enable(to_enable)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local parser_dir = vim.fn.stdpath 'data' .. '/treesitter'
    vim.opt.runtimepath:prepend(parser_dir)

    local ok, ts = pcall(require, 'nvim-treesitter.configs')
    if not ok then
      vim.notify('nvim-treesitter not available', vim.log.levels.WARN)
      return
    end

    ts.setup {
      parser_install_dir = parser_dir,
      ensure_installed = {
        'bash',
        'fish',
        'gitcommit',
        'graphql',
        'html',
        'json',
        'json5',
        'lua',
        'markdown',
        'markdown_inline',
        'regex',
        'scss',
        'toml',
        'tsx',
        'javascript',
        'typescript',
        'yaml',
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<cr>',
          node_incremental = '<cr>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    }
  end,
})

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
  lua = {
    {
      bin = 'stylua',
      args = { '--stdin-filepath', '$FILENAME', '-' },
      configs = { 'stylua.toml', '.stylua.toml' },
    },
  },
  javascript = {
    {
      bin = 'prettierd',
      args = { '$FILENAME' },
      configs = {
        '.prettierrc',
        '.prettierrc.json',
        'prettier.config.js',
        '.prettierrc.js',
        'package.json',
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

local function find_root(start_path, markers)
  local result = vim.fs.find(
    markers,
    { path = start_path, upward = true, stop = vim.env.HOME }
  )
  if result and #result > 0 then
    return vim.fs.dirname(result[1])
  end
  return nil
end

local function resolve_formatter(ft, bufnr)
  local options = candidates[ft]
  while type(options) == 'string' do
    options = candidates[options]
  end
  if not options then
    return nil
  end

  local buf_path = vim.api.nvim_buf_get_name(bufnr)
  local buf_dir = vim.fs.dirname(buf_path)

  for _, tool in ipairs(options) do
    if utils.is_bin_available(tool.bin) then
      if not tool.configs then
        return tool
      end

      local found_config = find_root(buf_dir, tool.configs)
      if found_config then
        return tool, found_config
      end
    end
  end

  return nil
end

local function run_cli_formatter(bufnr)
  if is_oil_buffer(bufnr) then
    return false
  end

  local tool, config_root = resolve_formatter(vim.bo[bufnr].filetype, bufnr)
  if not tool then
    return false
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = concat(lines, '\n')
  local full_path = vim.api.nvim_buf_get_name(bufnr)
  local cmd = { tool.bin }

  for _, arg in ipairs(tool.args) do
    insert(cmd, arg == '$FILENAME' and full_path or arg)
  end

  local cwd = config_root
  if not cwd then
    cwd = find_root(vim.fs.dirname(full_path), { '.git' })
      or vim.fs.dirname(full_path)
  end

  local out = vim
    .system(cmd, {
      stdin = content,
      cwd = cwd,
    })
    :wait()

  if out.code == 0 and out.stdout and out.stdout ~= '' then
    local new_lines = vim.split(out.stdout, '\n')
    if new_lines[#new_lines] == '' then
      table.remove(new_lines)
    end
    if concat(new_lines, '\n') ~= content then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
    end
  end
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

  local buf_dir = vim.fs.dirname(filename)
  local root = vim.fs.find({ '.vscode' }, { upward = true, path = buf_dir })[1]

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

  vim.system(cmd, { cwd = buf_dir }, function(out)
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
    if run_cli_formatter(ev.buf) then
      return
    end

    local clients = vim.lsp.get_clients { bufnr = ev.buf }
    for _, client in ipairs(clients) do
      ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
      if client.supports_method 'textDocument/formatting' then
        vim.lsp.buf.format { bufnr = ev.buf, async = false }
        break
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
