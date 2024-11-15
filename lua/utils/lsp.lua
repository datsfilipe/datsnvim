local M = {}

M.check_for_binary = function(bin)
  local path = vim.fn.executable(bin)
  return path == 1
end

M.filter_by_disabled = function(configs)
  return vim.tbl_filter(function(key)
    local t = configs[key]
    if type(t) == 'table' then
      return t.disabled ~= true
    else
      return t
    end
  end, vim.tbl_keys(configs))
end

return M
