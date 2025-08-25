vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local parser_dir = vim.fn.stdpath 'data' .. '/treesitter'
    vim.opt.runtimepath:prepend(parser_dir)

    local ok, ts = pcall(require, 'nvim-treesitter.configs')
    if not ok then
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
        'jsonc',
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
