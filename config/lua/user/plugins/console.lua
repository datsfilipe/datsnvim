return {
  event = 'CmdlineEnter',
  commands = {
    { 'ConsoleRun', '', {} },
  },
  setup = function()
    require('console').setup {
      hijack_bang = true,
      close_key = ';q',
    }
  end,
}
