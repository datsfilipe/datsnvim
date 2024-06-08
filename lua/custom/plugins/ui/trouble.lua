return {
  'folke/trouble.nvim',
  keys = {
    { ';e', ':TroubleToggle<Return>' },
    {
      '<leader>n',
      function()
        local trouble = require 'trouble'

        if trouble.is_open() then
          trouble.next { skip_groups = true, jump = true }
        else
          trouble.open()
        end
      end,
    },
    {
      '<leader>p',
      function()
        local trouble = require 'trouble'

        if trouble.is_open() then
          trouble.prev { skip_groups = true, jump = true }
        else
          trouble.open()
        end
      end,
    },
  },
  opts = {
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
