return {
  'nvim-telescope/telescope.nvim',
  event = 'BufEnter',
  config = function()
    local builtin = require 'telescope.builtin'
    local actions = require 'telescope.actions'

    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-x>'] = false,
            ['<C-c>'] = function()
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes('<Esc>', true, true, true),
                'n',
                true
              )
            end,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-l>'] = actions.smart_send_to_qflist + actions.open_qflist,
          },
        },
        extensions = {
          wrap_results = true,

          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },

          ['ui-select'] = {
            require('telescope.themes').get_dropdown {},
          },
        },
      },
    }

    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'fzf')

    vim.keymap.set('n', ';f', builtin.find_files)
    vim.keymap.set('n', ';g', builtin.git_files)
    vim.keymap.set('n', ';r', builtin.live_grep)
    vim.keymap.set('n', ';c', builtin.current_buffer_fuzzy_find)
    vim.keymap.set('n', ';h', builtin.help_tags)
    vim.keymap.set('n', '\\\\', builtin.buffers)
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
}
