local config = require 'core.config'
local helpers = require 'plugins.code.lsp.helpers'

return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = 'if_many',
          prefix = '●',
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = config.signs.Error,
            [vim.diagnostic.severity.WARN] = config.signs.Warn,
            [vim.diagnostic.severity.HINT] = config.signs.Hint,
            [vim.diagnostic.severity.INFO] = config.signs.Info,
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
      codelens = {
        enabled = false,
      },
      capabilities = {},
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              format = {
                enable = vim.fn.executable 'stylua' == 1,
              },
              runtime = { version = 'LuaJIT' },
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      },
      setup = {},
    },
    config = function(_, opts)
      -- setup keymaps
      local register_capability = vim.lsp.handlers['client/registerCapability']
      vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local buffer = vim.api.nvim_get_current_buf()
        require('plugins.code.lsp.keymaps').on_attach(client, buffer)
        return ret
      end

      -- diagnostic signs
      if vim.fn.has 'nvim-0.10.0' == 0 then
        for severity, icon in pairs(opts.diagnostics.signs.text) do
          local name =
            vim.diagnostic.severity[severity]:lower():gsub('^%l', string.upper)
          name = 'DiagnosticSign' .. name
          vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
        end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- server setup
      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        server_opts.on_attach = function(client, bufnr)
          helpers.on_attach(client, bufnr, opts)
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup['*'] then
          if opts.setup['*'](server, server_opts) then
            return
          end
        end

        if server == 'eslint' then
          server_opts.on_attach = function(client, bufnr)
            vim.api.nvim_command 'autocmd BufWritePre <buffer> EslintFixAll'
            helpers.on_attach(client, bufnr, opts)
          end
        end

        if server == 'elixirls' then
          server_opts.cmd = { 'elixir-ls' }
        end

        require('lspconfig')[server].setup(server_opts)
      end

      -- get mason available servers
      local have_mason, mlsp = pcall(require, 'mason-lspconfig')
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(
          require('mason-lspconfig.mappings.server').lspconfig_to_package
        )
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if
            server_opts.mason == false
            or not vim.tbl_contains(all_mslp_servers, server)
          then
            setup(server)
          elseif server_opts.enabled ~= false then
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup { ensure_installed = ensure_installed, handlers = { setup } }
      end

      -- borders
      vim.lsp.handlers['textDocument/hover'] =
        vim.lsp.with(vim.lsp.handlers.hover, {
          border = 'rounded',
        })

      vim.lsp.handlers['textDocument/signatureHelp'] =
        vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = 'rounded',
        })
    end,
  },
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
    build = ':MasonUpdate',
    opts = {
      ensure_installed = {
        'stylua',
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require 'mason-registry'
      mr:on('package:install:success', function(pkg)
        helpers.patch_mason_binaries(pkg)

        vim.defer_fn(function()
          require('lazy.core.handler.event').trigger {
            event = 'FileType',
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
