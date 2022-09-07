local present, github = pcall(require, 'github-theme')
if not present then
  return
end

github.setup({
  theme_style = "dark",
  function_style = "italic",
  colors = {
    bg = '#000000'
  }
})
