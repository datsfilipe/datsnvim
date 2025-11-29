local M = {}

function M.setup()
  if M._loaded then
    return
  end
  M._loaded = true

  local ok, fidget = pcall(require, 'fidget')
  if not ok then
    return
  end

  fidget.setup { progress = { display = { done_icon = 'OK' } } }
end

return M
