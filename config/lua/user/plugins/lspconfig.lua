local utils = require 'user.utils'
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
  local function keymap(lhs, rhs, desc)
    vim.keymap.set(
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
  vim.lsp.buf.hover = function()
    return vim.lsp.handlers.hover(nil, nil, nil, {
      border = 'none',
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    })
  end

  vim.lsp.buf.signature_help = function()
    return vim.lsp.handlers.signature_help(nil, nil, nil, {
      border = 'none',
      focusable = false,
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    })
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

return {
  event = { 'BufReadPre', 'BufNewFile' },
  setup = function()
    local ok, lspconfig = pcall(require, 'lspconfig')
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
        if srv.name == 'ts_ls' then
          cfg.capabilities = vim.tbl_extend('force', cfg.capabilities or {}, {
            documentFormattingProvider = false,
            documentRangeFormattingProvider = false,
          })
        end
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
}
