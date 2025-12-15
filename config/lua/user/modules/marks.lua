local ns = vim.api.nvim_create_namespace 'user/marks'

local utils = require 'user.utils'
local map = utils.map

map('n', 'dm', function()
  local cur_line = vim.fn.line '.'
  local marks = vim.fn.getmarklist(vim.api.nvim_get_current_buf())

  local global_marks = vim.fn.getmarklist()
  for _, mark in ipairs(global_marks) do
    if mark.pos[1] == vim.api.nvim_get_current_buf() then
      table.insert(marks, mark)
    end
  end

  local deleted = false
  for _, mark in ipairs(marks) do
    if mark.pos[2] == cur_line then
      local mark_name = string.sub(mark.mark, 2)
      if mark_name:match '^[a-zA-Z]$' then
        vim.cmd('delmarks ' .. mark_name)
        print('deleted mark ' .. mark_name)
        deleted = true
      end
    end
  end

  if deleted then
    vim.api.nvim_buf_clear_namespace(0, ns, cur_line - 1, cur_line)
  else
    print 'no mark found on this line'
  end
end, { desc = 'delete mark' })

-- taken from https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/marks.lua
---@param bufnr integer
---@param mark vim.fn.getmarklist.ret.item
local function decor_mark(bufnr, mark)
  pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, mark.pos[2] - 1, 0, {
    sign_text = mark.mark:sub(2),
    sign_hl_group = 'DiagnosticSignOk',
  })
end

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, bufnr, top_row, bot_row)
    if vim.api.nvim_buf_get_name(bufnr) == '' then
      return
    end

    vim.api.nvim_buf_clear_namespace(bufnr, ns, top_row, bot_row)

    local current_file = vim.api.nvim_buf_get_name(bufnr)

    for _, mark in ipairs(vim.fn.getmarklist()) do
      if mark.mark:match '^.[a-zA-Z]$' then
        local mark_file = vim.fn.fnamemodify(mark.file, ':p:a')
        if current_file == mark_file then
          decor_mark(bufnr, mark)
        end
      end
    end

    for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
      if mark.mark:match '^.[a-zA-Z]$' then
        decor_mark(bufnr, mark)
      end
    end
  end,
})

vim.on_key(function(_, typed)
  if typed:sub(1, 1) ~= 'm' then
    return
  end

  local mark = typed:sub(2)

  vim.schedule(function()
    if mark:match '[A-Z]' then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        vim.api.nvim__redraw { win = win, range = { 0, -1 } }
      end
    else
      vim.api.nvim__redraw { range = { 0, -1 } }
    end
  end)
end, ns)
