return {
  {
    'echasnovski/mini-git',
    main = 'mini.git',
    cmd = 'Git',
    opts = {},
    keys = {
      {
        'gs',
        function()
          local status_output = vim.fn.system 'git status --porcelain'
          local qf_list = {}
          for file in status_output:gmatch '[^\r\n]+' do
            local status = file:sub(1, 2)
            local filename = file:sub(4)
            table.insert(qf_list, { filename = filename, text = status })
          end
          vim.fn.setqflist(qf_list)
          vim.cmd 'copen'
        end,
        desc = 'git status',
      },
      { 'gA', '<cmd>Git add %<cr>' },
      { 'gc', '<cmd>Git commit<cr>' },
      { 'ge', '<cmd>vert Git diff %<cr>' },
      { 'gE', '<cmd>vert Git diff<cr>' },
      { 'gl', '<cmd>vert Git log<cr>' },
      { 'gP', ':Git push origin ' },
      {
        'gi',
        function()
          require('mini.git').show_at_cursor { split = 'vertical' }
        end,
        desc = 'show info at cursor',
        mode = { 'n', 'x' },
      },
    },
  },
}
