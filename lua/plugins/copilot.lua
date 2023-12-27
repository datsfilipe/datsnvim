local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set('n', '<leader>cp', ':Copilot panel<Return>', opts)
keymap.set('n', '<leader>ce', ':Copilot enable<Return>', opts)
keymap.set('n', '<leader>cd', ':Copilot disable<Return>', opts)
keymap.set('n', '<leader>cs', ':Copilot status<Return>', opts)

return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enable = true,
      auto_trigger = true,
      keymap = {
        accept = '<C-Space>',
      },
    },
  },
}
