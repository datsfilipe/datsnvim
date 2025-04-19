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
      noremap = true,
    },
    { ';gA', '<cmd>Git add %<cr>', desc = 'add file', noremap = true },
    {
      ';gr',
      '<cmd>Git reset HEAD --<cr>',
      desc = 'unstage all changes',
      noremap = true,
    },
    { ';gc', '<cmd>Git commit<cr>', desc = 'commit', noremap = true },
    { ';gd', '<cmd>vert Git diff %<cr>', desc = 'diff file', noremap = true },
    { ';gD', '<cmd>vert Git diff<cr>', desc = 'diff all', noremap = true },
    { ';gl', '<cmd>vert Git log<cr>', desc = 'log', noremap = true },
    {
      ';gb',
      '<cmd>vert Git blame HEAD -- %<cr>',
      desc = 'blame',
      noremap = true,
    },
    {
      ';gB',
      function()
        vim.ui.input(
          { prompt = 'base branch (default: origin/main): ' },
          function(branch)
            branch = branch ~= '' and branch or 'origin/main'
            vim.cmd('vert Git diff ' .. branch .. '...HEAD')
          end
        )
      end,
      desc = 'diff current branch against default branch',
      noremap = true,
    },
    {
      ';gp',
      function()
        require('extensions.minigit').create_pr()
      end,
      desc = 'create pull request',
      noremap = true,
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
