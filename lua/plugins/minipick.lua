return {
  'echasnovski/mini.pick',
  main = 'mini.pick',
  cmd = 'Pick',
  keys = {
    { ';f', '<cmd>Pick files<cr>', desc = 'files' },
    { ';r', '<cmd>Pick grep_live<cr>', desc = 'grep' },
    { '\\\\', '<cmd>Pick buffers<cr>', desc = 'search buffers' },
  },
  config = function()
    local pick = require 'mini.pick'
    pick.setup {
      delay = {
        async = 10,
        busy = 50,
      },
      mappings = {
        toggle_preview = '<Tab>',
        choose_all = {
          char = '<C-e>',
          func = function()
            local mappings = pick.get_picker_opts().mappings
            vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
          end,
        },
      },
      options = {
        content_from_bottom = false,
        use_cache = true,
      },
      window = {
        config = {
          border = 'none',
        },
        prompt_cursor = '█',
        prompt_prefix = ': ',
      },
      source = { show = pick.default_show },
    }
  end,
}
