local status_ok, notify = pcall(require, 'notify')
if not status_ok then
  return
end

notify.setup({
  stages = 'slide',
  timeout = 2500,
  minimum_width = 50,
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  }
})
