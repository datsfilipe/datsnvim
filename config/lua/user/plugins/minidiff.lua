local M = {}

function M.setup()
  if M._loaded then
    return
  end
  M._loaded = true

  local ok, diff = pcall(require, 'mini.diff')
  if not ok then
    return
  end

  diff.setup {
    mappings = {
      reset = ';gr',
      apply = ';ga',
      goto_prev = '',
      goto_next = '',
    },
  }
end

return M
