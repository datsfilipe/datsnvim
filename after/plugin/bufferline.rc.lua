local status, bufferline = pcall(require, "bufferline")
if (not status) then return end

bufferline.setup({
  options = {
    mode = 'tabs',
    show_tab_indicators = false,
    show_close_icon = false,
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    always_show_bufferline = false,
    separator_style = { '', '' },
    indicator = {
      style = "underline"
    },
  },
  highlights = {
    fill = {
      bg = "NONE"
    },
    tab_selected = {
      fg = '#ebdbb2',
      bg = 'NONE',
      bold = true,
      italic = false,
    },
    buffer_selected = {
      fg = '#ebdbb2',
      bg = 'NONE',
      bold = true,
      italic = false,
    },
  }
})

vim.keymap.set('n', '<leader><Tab>n', '<Cmd>tabnew<CR>')
vim.keymap.set('n', '<leader><Tab>d', '<Cmd>tabclose<CR>')
vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
