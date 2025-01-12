return {
  {
    'echasnovski/mini.hipatterns',
    main = 'mini.hipatterns',
    event = { 'BufReadPost' },
    config = function()
      local hipatterns = require 'mini.hipatterns'
      local rgb = require 'extensions.highlighters.rgb'

      hipatterns.setup {
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
          rgb_color = rgb.default,
          rgba_color = rgb.rgba,
        },
      }
    end,
  },
}
