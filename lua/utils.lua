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

-- this fn was taken from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/util.lua
M.insert_package_json = function(config_files, field, fname)
  local path = vim.fn.fnamemodify(fname, ':h')
  local root_with_package = vim.fs.find(
    { 'package.json', 'package.json5' },
    { path = path, upward = true }
  )[1]

  if root_with_package then
    for line in io.lines(root_with_package) do
      if line:find(field) then
        config_files[#config_files + 1] = vim.fs.basename(root_with_package)
        break
      end
    end
  end
  return config_files
end

return M
