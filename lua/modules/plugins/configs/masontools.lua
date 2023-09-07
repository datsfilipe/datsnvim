local ok, masontools = pcall(require, 'mason-tool-installer')
if not ok then
  return
end

masontools.setup {
  ensure_installed = {
    'eslint_d',
    'prettierd',
    'rust_analyzer',
    'stylua'
  },
}