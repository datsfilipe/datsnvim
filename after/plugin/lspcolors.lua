local ok, colors = pcall(require, 'lsp-colors')
if not ok then
  return
end

colors.setup {}
