local present, github = pcall(require, "github-theme")
if not present then
  return
end

github.setup({
  options = {
    transparent = true,
  }
})

vim.cmd('colorscheme github_dark')

vim.cmd('hi IndentBlanklineIndent1 guifg=#2a2e36')
vim.cmd('hi LineNr guifg=#3e4452')