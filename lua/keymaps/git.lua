local status_functions = require 'custom.git.status'
local utils_functions = require 'custom.git.utils'
local push_functions = require 'custom.git.push'
local pr_functions = require 'custom.git.pr'

vim.keymap.set('n', '<leader>gm', function()
  pr_functions.create()
end, { silent = true })
vim.keymap.set(
  'n',
  '<leader>gA',
  '<cmd>silent !git add %<cr>',
  { silent = true }
)
vim.keymap.set(
  'n',
  '<leader>gu',
  '<cmd>silent !git reset HEAD --<cr>',
  { silent = true }
)
vim.keymap.set('n', '<leader>gb', '<cmd>CustomGitBlame<cr>', { silent = true })
vim.keymap.set('n', '<leader>gd', function()
  local current_file = vim.fn.expand '%:p'
  local output = vim.fn.system 'git diff ' .. current_file
  local line_count = vim.fn.len(vim.fn.split(output, '\n'))
  if line_count > 1 then
    utils_functions.create_git_buffer(output, 'diff', true)
  else
    vim.notify('no changes to show', vim.log.levels.INFO)
  end
end, { silent = true })
vim.keymap.set('n', '<leader>gD', function()
  local output = vim.fn.system 'git diff'
  utils_functions.create_git_buffer(output, 'diff', true)
end, { silent = true })
vim.keymap.set('n', '<leader>gl', function()
  local output = vim.fn.system 'git log'
  utils_functions.create_git_buffer(output, 'git', true)
end, { silent = true })
vim.keymap.set(
  'n',
  '<leader>gs',
  status_functions.git_status_quickfix,
  { silent = true }
)
vim.keymap.set(
  'n',
  '<leader>gp',
  push_functions.git_push_with_prompt,
  { silent = true }
)
vim.keymap.set(
  'n',
  '<leader>gP',
  '<cmd>silent !git push origin<cr>',
  { silent = true }
)
