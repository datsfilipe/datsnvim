local M = {}

local function pad_right(str, length)
  return str .. string.rep(' ', length - #str)
end

local function ensure_text_width(text, width)
  local text_width = vim.fn.strchars(text)
  if text_width > width then
    return vim.fn.strcharpart(text, 0, width - 3) .. '...'
  end
  return text
end

function M.setup(pick)
  pick.registry.keymaps = function()
    local items = {}
    local populate_modes = { 'n', 'x', 's', 'o', 'i', 'l', 'c', 't' }
    local max_lhs_width = 0

    local populate_items = function(source)
      for _, m in ipairs(populate_modes) do
        for _, maparg in ipairs(source(m)) do
          local desc = maparg.desc ~= nil and vim.inspect(maparg.desc)
            or maparg.rhs
          local lhs = vim.fn.keytrans(maparg.lhsraw or maparg.lhs)
          max_lhs_width = math.max(vim.fn.strchars(lhs), max_lhs_width)
          table.insert(items, { lhs = lhs, desc = desc, maparg = maparg })
        end
      end
    end

    populate_items(vim.api.nvim_get_keymap)

    for _, item in ipairs(items) do
      local lhs_text =
        pad_right(ensure_text_width(item.lhs, max_lhs_width), max_lhs_width)
      item.text = string.format(
        '%s | %s | %s',
        item.maparg.mode,
        lhs_text,
        item.desc or ''
      )
    end

    local source = {
      items = items,
      name = 'Keymaps (%s)',
      choose = function() end,
    }

    local chosen_picker_name = pick.start { source = source }
    if chosen_picker_name == nil then
      return
    end
    return pick.registry[chosen_picker_name]()
  end
end

return M
