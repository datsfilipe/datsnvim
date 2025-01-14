return {
  'shellRaining/hlchunk.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local static_color = require('utils').static_color

    require('hlchunk').setup {
      chunk = {
        enable = false,
        notify = false,
      },
      indent = {
        enable = true,
        style = {
          { fg = static_color },
        },
      },
      line_num = { enable = false },
      blank = { enable = false },
    }
  end,
}
