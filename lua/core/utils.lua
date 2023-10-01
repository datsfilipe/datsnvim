local M = {}

M.map = function(table)
  vim.keymap.set(table[1], table[2], table[3], table[4])
end

M.diagnostic_symbols = {
  error = "",
  warn = "",
  info = "",
  hint = "󰌶",
}

-- gh
local function return_project_root()
  local path = vim.fn.expand "%:p:h"
  local git_path = vim.fn.finddir(".git", path .. ";")
  if git_path == "" then
    return nil
  else
    return vim.fn.fnamemodify(git_path, ":h")
  end
end

M.create_pr = function()
  local template_path = return_project_root() .. "/.github/pull_request_template.md"

  vim.cmd("tabe " .. vim.fn.tempname())

  if vim.fn.filereadable(template_path) == 1 then
    local template_lines = vim.fn.readfile(template_path)
    vim.fn.setline(1, template_lines)
  end

  vim.cmd "setlocal filetype=markdown"
  vim.cmd "setlocal buftype=nofile"
  vim.cmd "setlocal bufhidden=delete"
end

M.submit_pr = function()
  local branch = "main"
  local title = vim.fn.getline(1)
  local body = vim.fn.join(vim.fn.getline(3, "$"), "\n")

  local cmd = string.format("gh pr -a @me create --base %s --title '%s' --body '%s'", branch, title, body)

  local _, result = pcall(vim.fn.system, cmd)
  print(result)
  vim.cmd "bd!"
end

-- autocmd
M.autocmd = function(args)
  local event = args[1]
  local group = args[2]
  local callback = args[3]

  vim.api.nvim_create_autocmd(event, {
    group = group,
    buffer = args[4],
    callback = function()
      callback()
    end,
    once = args.once,
  })
end

return M