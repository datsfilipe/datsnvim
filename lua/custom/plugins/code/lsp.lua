return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'folke/neodev.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      { 'j-hui/fidget.nvim', opts = {} },

      -- autoformatting
      'stevearc/conform.nvim',

      -- linting
      'mfussenegger/nvim-lint',

      -- schema information
      'b0o/SchemaStore.nvim',
    },
    config = function()
      require('neodev').setup {}

      local capabilities = nil
      if pcall(require, 'cmp_nvim_lsp') then
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      end

      local lspconfig = require 'lspconfig'

      local servers = {
        bashls = true,
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        lua_ls = {
          server_capabilities = {
            semanticTokensProvider = vim.NIL,
          },
        },
        rust_analyzer = true,
        templ = true,
        cssls = true,

        tsserver = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
        },
        biome = true,
        eslint = true,

        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },

        elixirls = {
          cmd = { 'elixir-ls' },
          root_dir = require('lspconfig.util').root_pattern { 'mix.exs' },
          server_capabilities = {
            -- completionProvider = true,
            -- definitionProvider = false,
            documentFormattingProvider = false,
          },
        },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == 'table' then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require('mason').setup()
      local ensure_installed = {
        'stylua',
        'lua_ls',
        'codespell',
        -- "tailwind-language-server",
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend('force', {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(
            vim.lsp.get_client_by_id(args.data.client_id),
            'must have valid client'
          )

          local settings = servers[client.name]
          if type(settings) ~= 'table' then
            settings = {}
          end

          local builtin = require 'telescope.builtin'

          vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = 0 })
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = 0 })
          vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, { buffer = 0 })
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })

          vim.keymap.set(
            'n',
            '<leader>vd',
            vim.diagnostic.open_float,
            { buffer = 0 }
          )
          vim.keymap.set(
            'n',
            '<leader>vws',
            vim.lsp.buf.workspace_symbol,
            { buffer = 0 }
          )
          vim.keymap.set(
            'n',
            '<leader>vrr',
            vim.lsp.buf.references,
            { buffer = 0 }
          )
          vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = 0 })

          vim.keymap.set(
            'n',
            '<leader>vca',
            vim.lsp.buf.code_action,
            { buffer = 0 }
          )
          vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, { buffer = 0 })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      -- autoformatting setup
      require('conform').setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          javascript = { { 'prettierd', 'prettier' } },
          typescript = { { 'prettierd', 'prettier' } },
        },
      }

      vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function(args)
          require('conform').format {
            bufnr = args.buf,
            lsp_fallback = true,
            quiet = true,
          }
        end,
      })

      -- linting setup
      require('lint').linters_by_ft = {}

      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint()
          require('lint').try_lint 'codespell'
        end,
      })

      -- diagnostics bg (if theme supports it)
      vim.diagnostic.config {
        signs = {
          linehl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticErrorLn',
            [vim.diagnostic.severity.WARN] = 'DiagnosticWarnLn',
          },
        },
      }
    end,
  },
}
