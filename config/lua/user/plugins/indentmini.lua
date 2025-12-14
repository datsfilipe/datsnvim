return {
  event = { 'BufReadPre', 'BufNewFile' },
  after = 'apply_transparency',
  setup = function()
    require('indentmini').setup {}
  end,
}
