return {
  'saghen/blink.cmp',
  build = 'nix run .#build-plugin',
  event = 'InsertEnter',
  opts = {
    keymap = {
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
    },
    completion = {
      list = {
        selection = {
          auto_insert = true,
          preselect = false,
        },
        max_items = 10,
      },
      menu = {
        border = 'none',
      },
      documentation = {
        auto_show = true,
        window = { border = 'none' },
      },
    },
    cmdline = { enabled = false },
    appearance = {
      kind_icons = require('icons').symbol_kinds,
    },
  },
  config = function(_, opts)
    require('blink.cmp').setup(opts)

    vim.lsp.config(
      '*',
      { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) }
    )
  end,
}
