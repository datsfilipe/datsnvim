local status, bufferline = pcall(require, "bufferline")
if (not status) then return end

bufferline.setup({
  options = {
    mode = "tabs",
    separator_style = 'slant',
    always_show_bufferline = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = true
  },
  highlights = {
    separator = {
      fg = '#ee5396',
      bg = '#262626',
    },
    separator_selected = {
      fg = '#ee5396',
    },
    background = {
      fg = '#ee5396',
      bg = '#363636'
    },
    buffer_selected = {
      fg = '#42be65',
      bold = true,
    },
    fill = {
      bg = '#262626'
    }
  },
})

vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
