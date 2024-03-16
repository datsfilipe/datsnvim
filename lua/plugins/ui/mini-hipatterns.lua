return {
  'echasnovski/mini.hipatterns',
  version = false,
  event = 'VeryLazy',
  opts = function()
    local hipatterns = require 'mini.hipatterns'
    local hsl = require 'utils.hsl'

    return {
      highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color(),
        hsl_color = {
          pattern = 'hsl%(%d+,? %d+,? %d+%)',
          group = function(_, match)
            local h, s, l = match:match 'hsl%((%d+),? (%d+),? (%d+)%)'
            h, s, l = tonumber(h), tonumber(s), tonumber(l)
            local hex_color = hsl.hslToHex(h, s, l)
            return hipatterns.compute_hex_color_group(hex_color, 'bg')
          end,
        },
      },
    }
  end,
}
