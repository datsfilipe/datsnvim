local M = {}

function M.open()
  vim.fn.system 'xdg-open https://excalidraw.com'

  local clipboard_command
  if vim.fn.executable 'xclip' == 1 then
    clipboard_command = 'xclip -selection clipboard'
  elseif vim.fn.executable 'wl-copy' == 1 then
    clipboard_command = 'wl-copy'
  else
    print 'Error: Neither xclip nor wl-copy is available for clipboard copying.'
    return
  end

  vim.fn.system('echo ' .. vim.fn.expand '%:p:h' .. ' | ' .. clipboard_command)
end

return M
