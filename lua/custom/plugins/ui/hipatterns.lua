return {
  'echasnovski/mini.hipatterns',
  version = false,
  opts = function()
    local hipatterns = require 'mini.hipatterns'
    local color_utils = require 'utils.color_utils'

    local function create_color_highlighter(pattern, extract_fn)
      return {
        pattern = pattern,
        group = function(_, match)
          local hex_color = extract_fn(match)
          if hex_color:len() > 7 then
            hex_color = hex_color:sub(1, 7)
          end
          return hipatterns.compute_hex_color_group(hex_color, 'bg')
        end,
      }
    end

    local function extract_hsl(match)
      local h, s, l = match:match 'hsl%((%d+),? (%d+),? (%d+)%)'
      return color_utils.hslToHex(tonumber(h), tonumber(s), tonumber(l))
    end

    local function extract_rgb(match)
      local r, g, b = match:match 'rgb%((%d+),? (%d+),? (%d+)%)'
      return string.format(
        '#%02x%02x%02x',
        tonumber(r),
        tonumber(g),
        tonumber(b)
      )
    end

    local function extract_rgba(match)
      local r, g, b = match:match 'rgba%((%d+),? (%d+),? (%d+),? [%d%.]+%)'
      return string.format(
        '#%02x%02x%02x',
        tonumber(r),
        tonumber(g),
        tonumber(b)
      )
    end

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
        hsl_color = create_color_highlighter(
          'hsl%(%d+,? %d+,? %d+%)',
          extract_hsl
        ),
        rgb_color = create_color_highlighter(
          'rgb%(%d+,? %d+,? %d+%)',
          extract_rgb
        ),
        rgba_color = create_color_highlighter(
          'rgba%(%d+,? %d+,? %d+,? [%d%.]+%)',
          extract_rgba
        ),
      },
    }
  end,
}
