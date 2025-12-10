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
    interactive = {
      fzf = function(output)
        local path = output:gsub('^%s*(.-)%s*$', '%1')
        if path ~= '' then
          print('opening: ' .. path)
          vim.cmd('edit ' .. vim.fn.fnameescape(path))
        end
      end,
    },
  }
end

return M
