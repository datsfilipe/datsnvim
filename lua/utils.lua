local M = {}

M.static_color = '#343434'

M.is_bin_available = function(bin)
  local path = vim.fn.executable(bin)
  return path == 1
end

M.is_file_available = function(file)
  local path = vim.fn.findfile(file, '.;')
  return path ~= ''
end

return M
