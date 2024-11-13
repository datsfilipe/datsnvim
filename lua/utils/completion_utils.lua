local M = {}

local function get_kind_priority(kind)
  local kind_str = type(kind) == 'number'
      and vim.lsp.protocol.CompletionItemKind[kind]
    or kind

  for i, k in ipairs(require('utils.config').kind_priorities) do
    if k == kind_str then
      return 1 / i
    end
  end
  return 0
end

M.table_get = function(t, id)
  if type(id) ~= 'table' then
    return M.table_get(t, { id })
  end
  local success, res = true, t
  for _, i in ipairs(id) do
    success, res = pcall(function()
      return res[i]
    end)
    if not success or res == nil then
      return
    end
  end
  return res
end

M.get_completion_word = function(item)
  return M.table_get(item, { 'textEdit', 'newText' })
    or item.insertText
    or item.label
    or ''
end

M.should_come_first = function(a, b, base)
  local a_text = a.filterText or M.get_completion_word(a)
  local b_text = b.filterText or M.get_completion_word(b)

  local a_starts_with_symbol = a_text:match '^[^%w]'
  local b_starts_with_symbol = b_text:match '^[^%w]'
  local base_starts_with_symbol = base:match '^[^%w]'

  if
    a_starts_with_symbol ~= b_starts_with_symbol and not base_starts_with_symbol
  then
    return not a_starts_with_symbol
  end

  local a_priority = get_kind_priority(a.kind)
  local b_priority = get_kind_priority(b.kind)

  if a_priority ~= b_priority then
    return a_priority > b_priority
  end

  return a.label < b.label
end

return M
