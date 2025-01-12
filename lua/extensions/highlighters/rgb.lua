local function matcher(type, match)
  if type == 'rgb' then
    local r, g, b = match:match 'rgb%s*%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)'
    return { r = r, g = g, b = b, a = nil }
  else
    local r, g, b, a =
      match:match 'rgba%s*%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*,%s*([%d%.]+)'
    return { r = r, g = g, b = b, a = a }
  end
end

local function gen_highlighter(type)
  return {
    pattern = type == 'rgb' and '()rgb%s*%(%s*%d+%s*,%s*%d+%s*,%s*%d+%s*%)()'
      or '()rgba%s*%(%s*%d+%s*,%s*%d+%s*,%s*%d+%s*,%s*[%d%.]+%s*%)()',
    group = function(_, match)
      local colors = matcher(type, match)
      print(colors.r, colors.g, colors.b)
      if not (colors.r and colors.g and colors.b) then
        return 'Normal'
      end

      local hex = string.format(
        '#%02x%02x%02x',
        tonumber(colors.r),
        tonumber(colors.g),
        tonumber(colors.b)
      )
      local hl_group =
        string.format('MiniHipatternsColor_%s', hex:gsub('#', ''))

      vim.api.nvim_set_hl(0, hl_group, { bg = hex, fg = '#000000' })
      return hl_group
    end,
  }
end

return {
  default = gen_highlighter 'rgb',
  rgba = gen_highlighter 'rgba',
}
