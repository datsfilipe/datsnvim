local ok_settings, settings = pcall(require, 'user.settings')
local theme = (ok_settings and settings.get().theme)
  or vim.g.datsnvim_theme
  or 'vesper'

local ok, mod = pcall(require, 'user.plugins.colorschemes.' .. theme)
if ok then
  return mod
end

return {}
