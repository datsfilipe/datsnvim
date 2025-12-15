require('fidget').setup {
  progress = {
    display = {
      done_icon = 'OK',
    },
  },
  notification = {
    override_vim_notify = true,
    configs = {
      default = { icon = '', name = '' },
    },
  },
}
