local M = {}

function M.init(enable)
  if not enable then
    return
  end

  local function notify()
    local msg = "Training time!"
    vim.notify(msg, vim.log.levels.INFO, {
      icon = "🐒",
      title = "Monkeytype",
      timeout = 5000,
    })
  end

  local function open_monkeytype()
    notify()
    local url = "https://monkeytype.com/"
    local cmd = string.format("silent !xdg-open %s", url)
    vim.cmd(cmd)
  end

  local run_period = 60 * 30 * 1000 -- 30 minutes

  local timer = vim.loop.new_timer()
  timer:start(0, run_period, vim.schedule_wrap(open_monkeytype))
end

return M
