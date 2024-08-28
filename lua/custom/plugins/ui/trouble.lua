return {
  'folke/trouble.nvim',
  dependencies = {
    'artemave/workspace-diagnostics.nvim',
  },
  keys = {
    {
      ';e',
      function()
        if not vim.g.workspace_diagnostics_populated then
          for _, client in ipairs(vim.lsp.get_clients()) do
            if client.attached_buffers[vim.api.nvim_get_current_buf()] then
              require('workspace-diagnostics').populate_workspace_diagnostics(
                client,
                0
              )
            end
          end
          vim.g.workspace_diagnostics_populated = true
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
