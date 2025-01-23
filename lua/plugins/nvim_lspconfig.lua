return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('lspconfig.ui.windows').default_options.border = 'none'

    local configure_server = require('extensions.lsp.server').configure_server
    local utils = require 'utils'

    local handle_configure_server = function(server, binary)
      if not utils.is_bin_available(binary) then
        return
      end
      configure_server(server.name, server.opts)
    end

    handle_configure_server({ name = 'gopls', opts = {} }, 'gopls')
    handle_configure_server({ name = 'biome', opts = {} }, 'biome')
    handle_configure_server(
      { name = 'bashls', opts = {} },
      'bash-language-server'
    )
    handle_configure_server(
      { name = 'jsonls', opts = {} },
      'vscode-json-languageserver'
    )

    handle_configure_server({
      name = 'rust_analyzer',
      opts = {
        settings = {
          ['rust-analyzer'] = {
            inlayHints = {
              enable = false,
            },
          },
        },
      },
    }, 'rust-analyzer')

    handle_configure_server({
      name = 'eslint',
      opts = {
        filetypes = {
          'graphql',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        settings = { format = true },
      },
    }, 'vscode-eslint-language-server')

    handle_configure_server({
      name = 'ts_ls',
      opts = {
        server_capabilities = {
          documentFormattingProvider = false,
        },
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
      },
    }, 'typescript-language-server')

    handle_configure_server({
      name = 'lua_ls',
      opts = {
        ---@param client vim.lsp.Client
        on_init = function(client)
          local path = client.workspace_folders
            and client.workspace_folders[1]
            and client.workspace_folders[1].name
          if not path then
            client.config.settings =
              vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                  runtime = {
                    version = 'LuaJIT',
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME,
                      '${3rd}/luv/library',
                    },
                  },
                },
              })
            client.notify(
              vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
              { settings = client.config.settings }
            )
          end

          return true
        end,
        settings = {
          Lua = {
            format = { enable = false },
            hint = {
              enable = true,
              arrayIndex = 'Disable',
            },
            completion = { callSnippet = 'Replace' },
          },
        },
      },
    }, 'lua-language-server')

    handle_configure_server({
      name = 'cssls',
      opts = {
        init_options = {
          provideFormatter = false,
        },
      },
    }, 'vscode-css-language-server')
  end,
}
