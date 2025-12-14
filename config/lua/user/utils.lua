local M = {}

M.map_options = { noremap = true, silent = true }
M.static_color = '#343434'

local bin_cache = {}
M.is_bin_available = function(bin)
  if bin_cache[bin] == nil then
    bin_cache[bin] = vim.fn.executable(bin) == 1
  end
  return bin_cache[bin]
end

M.is_file_available = function(filename)
  local found = vim.fn.findfile(filename, '.;')
  return found ~= ''
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

M.map = function(mode, lhs, rhs, opts)
  vim.keymap.set(
    mode,
    lhs,
    rhs,
    vim.tbl_extend('force', { silent = true }, opts or {})
  )
end

return M
