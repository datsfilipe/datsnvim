return {
  'echasnovski/mini.hipatterns',
  version = false,
  opts = function()
    local hipatterns = require 'mini.hipatterns'
    local color_utils = require 'utils.color_utils'

    return {
      highlighters = {
        fixme = {
          pattern = '%f[%w]()FIXME()%f[%W]',
          group = 'MiniHipatternsFixme',
        },
        hack = {
          pattern = '%f[%w]()HACK()%f[%W]',
          group = 'MiniHipatternsHack',
        },
        todo = {
          pattern = '%f[%w]()TODO()%f[%W]',
          group = 'MiniHipatternsTodo',
        },
        note = {
          pattern = '%f[%w]()NOTE()%f[%W]',
          group = 'MiniHipatternsNote',
        },
        hex_color = hipatterns.gen_highlighter.hex_color(),
        rgb_color = {
          pattern = 'rgb%((%d+),? (%d+),? (%d+)%)',
          group = function(_, match)
            local r, g, b = match:match 'rgb%((%d+),? (%d+),? (%d+)%)'
            r, g, b = tonumber(r), tonumber(g), tonumber(b)
            local hex_color = color_utils.rgbToHex(r, g, b)
            return hipatterns.compute_hex_color_group(hex_color, 'bg')
          end,
        },
        hsl_color = {
          pattern = 'hsl%(%d+,? %d+,? %d+%)',
          group = function(_, match)
            local h, s, l = match:match 'hsl%((%d+),? (%d+),? (%d+)%)'
            h, s, l = tonumber(h), tonumber(s), tonumber(l)
            local hex_color = color_utils.hslToHex(h, s, l)
            return hipatterns.compute_hex_color_group(hex_color, 'bg')
          end,
        },
      },
    }
  end,
}
