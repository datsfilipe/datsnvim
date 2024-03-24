return {
  'michaelrommel/nvim-silicon',
  cmd = 'Silicon',
  opts = {
    font = 'JetBrainsMono Nerd Font=34;Noto Color Emoji=34',
    no_window_controls = true,
    pad_horiz = 80,
    pad_vert = 80,
    background = '#fff',
    tab_width = 2,
    theme = os.getenv 'HOME'
      .. '/.config/bat/themes/dtsf-machine/theme.tmTheme',
    to_clipboard = true,
    gobble = true,
    num_separator = '\u{258f} ',
    shadow_blur_radius = 16,
    shadow_offset_x = 8,
    shadow_offset_y = 8,
    shadow_color = '#000',
  },
}
