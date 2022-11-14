vim.g.copilot_filetypes = {
  ['*'] = true,
  ['yaml'] = true,
}

-- it will disable copilot on startup and avoid the delay of autocmd approach
vim.g.copilot_enabled = 0
-- this will allow me to enable it iven if Tab key is used for comp.nvim
vim.g.copilot_no_tab_map = 1
vim.g.copilot_assume_mapped = 1
vim.g.copilot_tab_fallback = ''

-- workaround for https://github.com/orgs/community/discussions/16800
vim.g.copilot_node_command = "/home/dtsf/.asdf/installs/nodejs/17.9.1/bin/node"
