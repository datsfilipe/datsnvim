local M = {}

function M.setup()
  if M._loaded then
    return
  end
  M._loaded = true

  local ok, indentmini = pcall(require, 'indentmini')
  if not ok then
    return
  end

  indentmini.setup {}
end

return M
