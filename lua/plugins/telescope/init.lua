return {
  'nvim-telescope/telescope.nvim',
  event = 'BufEnter',
  config = function()
    local telescope = require 'telescope'

    local maps = require 'plugins.telescope.keymaps'
    local vars = require 'plugins.telescope.vars'
    local extensions = require('plugins.telescope.extensions').extensions
    local builtin = require('plugins.telescope.vars').builtin

    local set_prompt_to_entry_value = function(prompt_bufnr)
      local entry = vars.action_state.get_selected_entry()
      if not entry or not type(entry) == 'table' then
        return
      end

      vars.action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
    end

    telescope.setup {
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '  ',
        entry_prefix = '  ',
        mappings = maps.inner_maps(vars.actions, vars.action_layout, set_prompt_to_entry_value),
        file_ignore_patterns = {
          'node_modules',
          '.git',
        },
      },
      extensions = extensions,
    }

    telescope.load_extension 'harpoon'
    telescope.load_extension 'fzf'

    maps.outer_maps(telescope.extensions, builtin)
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-dap.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
}
