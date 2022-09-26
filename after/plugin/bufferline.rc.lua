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
    -- set bufferline config colors with gruvbox colors
    fill = {
      bg = "NONE",
    },
    background = {
      fg = "#ebdbb2",
      bg = "NONE"
    },
    buffer_selected = {
      fg = "#ebdbb2",
      bg = "NONE",
      bold = true,
    },
    separator = {
      fg = "#282828",
      bg = "NONE",
    },
    separator_selected = {
      fg = "#ebdbb2",
    },
  },
})

vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
