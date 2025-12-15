for _, key in ipairs { 'h', 'j', 'k', 'l', 'w', 'b', 'e' } do
  local count = 0
  local timer = assert(vim.uv.new_timer())
  local map = key
  vim.keymap.set('n', key, function()
    if vim.v.count > 0 then
      count = 0
    end
    if count >= 5 and vim.bo.buftype ~= 'nofile' then
      local ok = pcall(vim.notify, 'not good enough!', vim.log.levels.ERROR, {
        id = 'improve',
        keep = function()
          return count >= 4
        end,
      })
      if not ok then
        return map
      end
    else
      count = count + 1
      timer:start(2000, 0, function()
        count = 0
      end)
      return map
    end
  end, { expr = true, silent = true })
end
