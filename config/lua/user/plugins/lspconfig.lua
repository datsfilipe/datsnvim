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
  {
    name = 'biome',
    bin = 'biome',
    cmd = { 'biome', 'lsp-proxy' },
  },
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
  {
    name = 'solidity_ls',
    bin = 'vscode-solidity-server',
  },
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
  {
    name = 'nil_ls',
    bin = 'nil',
  },
}

local function on_attach(client, bufnr)
  if client.name == 'ts_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  local function keymap(lhs, rhs, desc, mode, opts)
    mode = mode or 'n'
    vim.keymap.set(
      mode,
      lhs,
      rhs,
      vim.tbl_extend('force', { buffer = bufnr, desc = desc }, opts or {})
    )
  end

  keymap('ge', vim.diagnostic.setqflist, 'list diagnostics')
  keymap('gE', vim.diagnostic.open_float, 'show diagnostic under cursor')

  if client:supports_method(methods.textDocument_definition) then
    keymap('gd', vim.lsp.buf.definition, 'peek definition')
  end

  if client:supports_method(methods.textDocument_typeDefinition) then
    keymap('gt', vim.lsp.buf.definition, 'peek type definition')
  end

  if client:supports_method(methods.textDocument_documentHighlight) then
    local under_cursor_highlights_group =
      vim.api.nvim_create_augroup('cursor_highlights', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
      group = under_cursor_highlights_group,
      desc = 'highlight references under the cursor',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
      group = under_cursor_highlights_group,
      desc = 'clear highlight references',
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
        local special_sources = {
          ['Lua Diagnostics.'] = 'lua',
          ['Lua Syntax Check.'] = 'lua',
        }

        local message =
          diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
        if diagnostic.source then
          message = string.format(
            '%s %s',
            message,
            special_sources[diagnostic.source] or diagnostic.source
          )
        end
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
        local prefix = string.format(' %s ', diagnostic_icons[level])
        return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
      end,
    },

    signs = false,
  }

  local show_handler = vim.diagnostic.handlers.virtual_text.show
  assert(show_handler)
  local hide_handler = vim.diagnostic.handlers.virtual_text.hide
  vim.diagnostic.handlers.virtual_text = {
    show = function(ns, bufnr, diagnostics, opts)
      table.sort(diagnostics, function(diag1, diag2)
        return diag1.severity > diag2.severity
      end)
      return show_handler(ns, bufnr, diagnostics, opts)
    end,
    hide = hide_handler,
  }
end

local function wrap_handlers()
  local hover = vim.lsp.buf.hover
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.hover = function()
    return hover {
      border = 'none',
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    }
  end

  local signature_help = vim.lsp.buf.signature_help
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.signature_help = function()
    return signature_help {
      border = 'none',
      focusable = false,
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    }
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
    contents = vim.lsp.util._normalize_markdown(contents, {
      width = vim.lsp.util._make_floating_popup_size(contents, opts),
    })
    vim.bo[bufnr].filetype = 'markdown'
    vim.treesitter.start(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

    return contents
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
    if not ok or not lspconfig then
      return
    end

    configure_diagnostics()
    wrap_handlers()

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'lsp keymaps',
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
          return
        end

        on_attach(client, args.buf)
      end,
    })

    local to_enable = {}
    for _, srv in ipairs(servers) do
      if utils.is_bin_available(srv.bin) then
        local cfg = vim.tbl_deep_extend('force', {}, srv.config or {})

        if srv.name == 'ts_ls' then
          cfg.capabilities = cfg.capabilities or {}
          cfg.capabilities.documentFormattingProvider = false
          cfg.capabilities.documentRangeFormattingProvider = false
        end

        if srv.cmd then
          cfg.cmd = srv.cmd
        elseif not cfg.cmd and srv.bin:match '^vscode%-' then
          cfg.cmd = { srv.bin, '--stdio' }
        end

        local existing = vim.lsp.config[srv.name] or {}
        cfg = vim.tbl_deep_extend('force', existing, cfg)
        vim.lsp.config[srv.name] = cfg
        table.insert(to_enable, srv.name)
      end
    end

    if #to_enable > 0 then
      vim.lsp.enable(to_enable)
    end
  end,
}
