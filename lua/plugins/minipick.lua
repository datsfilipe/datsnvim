return {
  'echasnovski/mini.pick',
  main = 'mini.pick',
  event = 'BufReadPre',
  opts = {
    delay = {
      async = 10,
      busy = 50,
    },
    mappings = {
      toggle_preview = '<Tab>',
      choose_all = {
        char = '<C-e>',
        func = function()
          local mappings = MiniPick.get_picker_opts().mappings
          vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
        end,
      },
    },
    options = {
      content_from_bottom = false,
      use_cache = false,
    },
    window = {
      config = {
        border = 'none',
      },
      prompt_cursor = '█',
      prompt_prefix = ': ',
    },
  },
  keys = {
    { ';f', '<cmd>Pick files<cr>', desc = 'files' },
    { ';r', '<cmd>Pick grep_live<cr>', desc = 'grep' },
    { '\\\\', '<cmd>Pick buffers<cr>', desc = 'search buffers' },
  },
}
