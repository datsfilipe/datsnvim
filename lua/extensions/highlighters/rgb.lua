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

local function is_dark_color(r, g, b)
  r, g, b = r / 255, g / 255, b / 255
  local luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
  return luminance < 0.5
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

      local r, g, b = tonumber(colors.r), tonumber(colors.g), tonumber(colors.b)
      local hex = string.format('#%02x%02x%02x', r, g, b)
      local hl_group =
        string.format('MiniHipatternsColor_%s', hex:gsub('#', ''))

      local fg_color = is_dark_color(r, g, b) and '#FFFFFF' or '#000000'

      vim.api.nvim_set_hl(0, hl_group, { bg = hex, fg = fg_color })
      return hl_group
    end,
  }
end

return {
  default = gen_highlighter 'rgb',
  rgba = gen_highlighter 'rgba',
}
