return {
  'echasnovski/mini-git',
  main = 'mini.git',
  cmd = 'Git',
  opts = {},
  keys = {
    {
      ';gs',
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
      desc = 'status',
    },
    {
      ';ge',
      function()
        require('extensions.minigit').list_hunks()
      end,
      desc = 'list hunks',
    },
    {
      ';gR',
      '<cmd>Git reset HEAD --<cr>',
      desc = 'unstage all changes',
    },
    { ';gA', '<cmd>Git add %<cr>', desc = 'add file' },
    { ';gc', '<cmd>Git commit<cr>', desc = 'commit' },
    { ';gd', '<cmd>vert Git diff %<cr>', desc = 'diff file' },
    { ';gD', '<cmd>vert Git diff<cr>', desc = 'diff all' },
    { ';gl', '<cmd>vert Git log<cr>', desc = 'log' },
    {
      ';gb',
      '<cmd>vert Git blame HEAD -- %<cr>',
      desc = 'blame',
    },
    {
      ';gB',
      function()
        vim.ui.input(
          { prompt = 'Base branch (default: origin/main): ' },
          function(branch)
            branch = branch ~= '' and branch or 'origin/main'
            vim.cmd('vert Git diff ' .. branch .. '...HEAD')
          end
        )
      end,
      desc = 'diff PR against branch',
    },
    {
      ';gp',
      function()
        require('extensions.minigit').create_pr()
      end,
      desc = 'create pull request',
    },
  },
  init = function()
    local au_opts = {
      pattern = 'MiniGitCommandSplit',
      callback = require('extensions.minigit').align_blame,
    }
    vim.api.nvim_create_autocmd('User', au_opts)

    require('extensions.minigit').git_pr_setup {
      remotes = { 'fork', 'origin', 'develop', 'stage' },
    }
  end,
}
