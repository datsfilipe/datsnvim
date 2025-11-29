local theme = vim.g.datsnvim_theme or 'vesper'

local ok, mod = pcall(require, 'user.plugins.colorschemes.' .. theme)
if ok then
  return mod
end

return {}
