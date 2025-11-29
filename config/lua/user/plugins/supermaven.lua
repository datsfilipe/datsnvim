local M = {}

function M.setup()
  if M._loaded then
    return
  end
  M._loaded = true

  local ok, supermaven = pcall(require, 'supermaven-nvim')
  if not ok then
    return
  end

  supermaven.setup {
    keymaps = {
      accept_suggestion = '<C-g>',
    },
  }
end

return M
