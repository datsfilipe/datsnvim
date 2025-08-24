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

M.darken_color = function(color_int, factor)
  if not color_int or not factor then
    return nil
  end
  local r = bit.band(bit.rshift(color_int, 16), 0xff)
  local g = bit.band(bit.rshift(color_int, 8), 0xff)
  local b = bit.band(color_int, 0xff)

  r = math.max(0, math.floor(r * (1 - factor)))
  g = math.max(0, math.floor(g * (1 - factor)))
  b = math.max(0, math.floor(b * (1 - factor)))

  return string.format('#%02x%02x%02x', r, g, b)
end

return M
