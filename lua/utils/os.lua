local M = {}

M.is_nixos = function()
  local handle = io.popen 'nixos-version'

  if handle == nil then
    return false
  end

  local result = handle:read '*a'
  handle:close()
  return result ~= ''
end

return M
