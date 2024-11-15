local M = {}

vim.g.monkeytype_enabled = false

function M.init()
  if not vim.g.monkeytype_enabled then
    return
  end

  local function notify()
    local msg = 'Training time!'
    vim.notify(msg, vim.log.levels.INFO, {
      icon = '🐒',
      title = 'Monkeytype',
      timeout = 5000,
    })
  end

  local function open_monkeytype()
    notify()
    local url = 'https://monkeytype.com/'
    local cmd = string.format('silent !xdg-open %s', url)
    vim.cmd(cmd)
  end

  local run_period = 15 * 60 * 1000 -- 15 minutes

  local timer = vim.loop.new_timer()
  timer:start(run_period, run_period, vim.schedule_wrap(open_monkeytype))
end

vim.keymap.set('n', '<leader>mt', function()
  vim.g.monkeytype_enabled = not vim.g.monkeytype_enabled
  print(
    'Monkeytype surprise test is now '
      .. (vim.g.monkeytype_enabled and 'enabled' or 'disabled')
  )
end)

return M
