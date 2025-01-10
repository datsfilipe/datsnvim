return {
  'echasnovski/mini.pick',
  main = 'mini.pick',
  cmd = 'Pick',
  keys = {
    { ';f', '<cmd>Pick files<cr>', desc = 'files' },
    { ';r', '<cmd>Pick grep_live<cr>', desc = 'grep' },
    { ';k', '<cmd>Pick keymaps<cr>', desc = 'keymaps' },
    { '\\\\', '<cmd>Pick buffers<cr>', desc = 'search buffers' },
  },
  config = function()
    local pick = require 'mini.pick'
    local keymaps = require 'extensions.pickers.keymaps'

    pick.setup {
      delay = {
        async = 10,
        busy = 50,
      },
      mappings = {
        toggle_preview = '<Tab>',
        choose_all = {
          char = '<C-l>',
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
      source = {
        show = function(buf_id, items, query)
          return pick.default_show(
            buf_id,
            items,
            query,
            { show_icons = true, icons = { directory = 'D ', file = 'F ' } }
          )
        end,
      },
    }

    keymaps.setup(pick)
  end,
}
