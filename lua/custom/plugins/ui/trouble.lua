-- '<cmd><Return>'
return {
  'folke/trouble.nvim',
  dependencies = {
    'artemave/workspace-diagnostics.nvim',
  },
  keys = {
    {
      ';e',
      function()
        for _, client in ipairs(vim.lsp.get_clients()) do
          require('workspace-diagnostics').populate_workspace_diagnostics(
            client,
            0
          )
        end

        vim.cmd [[Trouble diagnostics toggle]]
      end,
    },
    { ';b', '<cmd>Trouble diagnostics toggle filter.buf=0<Return>' },
    { ']d', '<cmd>Trouble diagnostics next<Return>' },
    { '[d', '<cmd>Trouble diagnostics prev<Return>' },
  },
  opts = {
    focus = true,
    follow = true,
    use_diagnostic_signs = true,
    icons = {
      indent = {
        fold_open = ' ',
        fold_closed = ' ',
        ws = '',
      },
      folder_closed = '',
      folder_open = '',
      kinds = {
        Array = '',
        Boolean = '',
        Class = '',
        Constant = '',
        Constructor = '',
        Enum = '',
        EnumMember = '',
        Event = '',
        Field = '',
        File = '',
        Function = '',
        Interface = '',
        Key = '',
        Method = '',
        Module = '',
        Namespace = '',
        Null = '',
        Number = '',
        Object = '',
        Operator = '',
        Package = '',
        Property = '',
        String = '',
        Struct = '',
        TypeParameter = '',
        Variable = '',
      },
    },
  },
}
