local M = {}

M.static_color = '#343434'

M.is_bin_available = function(bin)
  local path = vim.fn.executable(bin)
  return path == 1
end

M.is_file_available = function(file)
  local root_dir = vim.fn.getcwd()
  local path = vim.fn.findfile(file, root_dir .. ';')
  return path ~= ''
end

M.format_files_in_dir = function(ext)
  if not require('utils').is_bin_available 'fd' then
    print 'fd is not available'
    return
  end

  local confirm =
    vim.fn.input('proceed with formatting ' .. ext .. ' files? [y/n] ')
  if confirm:lower() ~= 'y' then
    print 'operation cancelled'
    return
  end

  local ignore_dirs = { '.git', 'node_modules', 'target' }
  local exclude_args = table.concat(
    vim.tbl_map(function(dir)
      return '-E ' .. dir
    end, ignore_dirs),
    ' '
  )
  local cmd = string.format('fd -e %s %s', ext, exclude_args)

  local file_list = vim.fn.systemlist(cmd)
  if #file_list == 0 then
    print 'no matching files found'
    return
  end

  vim.cmd('args ' .. table.concat(file_list, ' '))
  vim.cmd 'silent argdo execute "normal gg=G" | update'
end

return M
