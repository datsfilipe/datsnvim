return {
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter',
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local keymap = function(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      keymap('n', ']g', function()
        if vim.wo.diff then
          return ']g'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true })

      keymap('n', '[g', function()
        if vim.wo.diff then
          return '[g'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true })

      keymap('n', '<leader>gs', ':Gitsigns stage_hunk<CR>')
      keymap('n', '<leader>gr', ':Gitsigns reset_hunk<CR>')
      keymap('v', '<leader>gs', ':Gitsigns stage_hunk<CR>')
      keymap('v', '<leader>gr', ':Gitsigns reset_hunk<CR>')
      keymap('n', '<leader>gu', gs.undo_stage_hunk)
      keymap('n', '<leader>gb', function()
        gs.blame_line { full = true }
      end)
      keymap('n', '<leader>gd', function()
        local is_git_head = false
        local left_win_id = vim.fn.win_getid(vim.fn.winnr 'h')

        if left_win_id ~= -1 then
          local filename = vim.fn.bufname(vim.fn.winbufnr(left_win_id))
          is_git_head = string.find(filename, '.git/HEAD') ~= nil
        end

        if left_win_id ~= -1 and is_git_head then
          vim.cmd 'wincmd h'
          vim.cmd 'q'
        else
          gs.diffthis '~'
        end
      end)
    end,
  },
}
