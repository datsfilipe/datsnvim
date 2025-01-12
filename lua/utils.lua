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

return M
