vim.g.minuet_virtualtext_enabled = false

return {
  'milanglacier/minuet-ai.nvim',
  event = 'InsertEnter',
  version = '*',
  config = function()
    if not vim.g.minuet_virtualtext_enabled then
      vim.api.nvim_create_autocmd('InsertEnter', {
        pattern = '*',
        command = 'Minuet virtualtext enable',
        once = true,
      })
      vim.g.minuet_virtualtext_enabled = true
    end

    require('minuet').setup {
      provider = 'openai_fim_compatible',
      n_completions = 1,
      context_window = 16000,
      provider_options = {
        openai_fim_compatible = {
          api_key = 'TERM',
          name = 'ollama',
          end_point = 'http://localhost:11434/v1/completions',
          model = 'qwen2.5-coder:7b',
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { '*' },
        show_on_completion_menu = false,
        keymap = {
          accept = '<C-g>',
          dismiss = '<C-e>',
        },
      },
    }
  end,
}
