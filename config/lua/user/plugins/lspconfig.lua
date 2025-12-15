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
