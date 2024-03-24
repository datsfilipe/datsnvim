return {
  'nvim-telescope/telescope.nvim',
  event = 'BufEnter',
  opts = function()
    local maps = require 'plugins.ui.telescope.keymaps'
    local vars = require 'plugins.ui.telescope.vars'
    local extensions = require('plugins.ui.telescope.extensions').extensions
    local builtin = require('plugins.ui.telescope.vars').builtin

    local set_prompt_to_entry_value = function(prompt_bufnr)
      local entry = vars.action_state.get_selected_entry()
      if not entry or not type(entry) == 'table' then
        return
      end

      vars.action_state
        .get_current_picker(prompt_bufnr)
        :reset_prompt(entry.ordinal)
    end

    require('telescope').load_extension 'fzf'
    maps.outer_maps(require('telescope').extensions, builtin)

    return {
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '  ',
        entry_prefix = '  ',
        mappings = maps.inner_maps(
          vars.actions,
          vars.action_layout,
          set_prompt_to_entry_value
        ),
        file_ignore_patterns = {
          'node_modules',
          '.git',
        },
      },
      extensions = extensions,
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
}
