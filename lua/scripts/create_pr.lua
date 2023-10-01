local M = {}

local function return_project_root()
  local path = vim.fn.expand "%:p:h"
  local git_path = vim.fn.finddir(".git", path .. ";")
  local git_file = vim.fn.findfile(".git", path .. ";")
  if git_path == "" and git_file == "" then
    return nil
  else
    return vim.fn.fnamemodify(git_path, ":h")
  end
end

M.create = function()
  local template_path = return_project_root() .. "/.github/pull_request_template.md"

  vim.cmd("tabe " .. vim.fn.tempname())

  if vim.fn.filereadable(template_path) == 1 then
    local template_lines = vim.fn.readfile(template_path)
    vim.fn.setline(1, template_lines)
  end

  vim.cmd "setlocal filetype=markdown"

  vim.cmd "autocmd BufWritePre <buffer> lua require('scripts.create_pr').submit()"
end

M.submit = function()
  local branch = "main"
  local title = vim.fn.getline(1)
  local body = vim.fn.join(vim.fn.getline(3, "$"), "\n")

  local cmd = string.format("gh pr -a @me create --base %s --title '%s' --body '%s'", branch, title, body)

  local _, result = pcall(vim.fn.system, cmd)
  print(result)
end

return M