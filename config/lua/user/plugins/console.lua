local M = {}

function M.setup()
  if M._loaded then
    return
  end
  M._loaded = true

  local ok, console = pcall(require, 'console')
  if not ok then
    return
  end

  console.setup {
    hijack_bang = true,
    close_key = ';q',
  }
end

return M
