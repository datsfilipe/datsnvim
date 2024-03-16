return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = false,
    },
    lsp = {
      signature = { enabled = false },
      hover = { enabled = false },
    },
  },
  dependencies = { 'MunifTanjim/nui.nvim' },
}
