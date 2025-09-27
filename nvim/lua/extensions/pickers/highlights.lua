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

local function dec_to_rgb(dec)
  if not dec or dec < 0 then
    return ''
  end
  local r = bit.band(bit.rshift(dec, 16), 0xff)
  local g = bit.band(bit.rshift(dec, 8), 0xff)
  local b = bit.band(dec, 0xff)
  return string.format('rgb(%d,%d,%d)', r, g, b)
end

local function dec_to_hex(dec)
  if not dec or dec < 0 then
    return ''
  end
  return string.format('#%06x', dec)
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

  pick.registry.highlights = function()
    local items = {}
    local max_name_width = 0

    local all_highlight_names = vim.fn.getcompletion('', 'highlight')

    for _, name in ipairs(all_highlight_names) do
      local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)

      if ok and hl and not vim.tbl_isempty(hl) then
        max_name_width = math.max(vim.fn.strwidth(name), max_name_width)

        local attrs = {}
        if hl.bold then
          table.insert(attrs, 'bold')
        end
        if hl.italic then
          table.insert(attrs, 'italic')
        end
        if hl.underline then
          table.insert(attrs, 'underline')
        end
        if hl.undercurl then
          table.insert(attrs, 'undercurl')
        end
        if hl.reverse then
          table.insert(attrs, 'reverse')
        end
        local attr_str = table.concat(attrs, ', ')

        local has_color = false
        if hl.foreground then
          has_color = true
          table.insert(items, {
            name = name,
            type = 'fg',
            hex = dec_to_hex(hl.foreground),
            rgb = dec_to_rgb(hl.foreground),
            attrs = attr_str,
          })
        end

        if hl.background then
          has_color = true
          table.insert(items, {
            name = name,
            type = 'bg',
            hex = dec_to_hex(hl.background),
            rgb = dec_to_rgb(hl.background),
            attrs = attr_str,
          })
        end

        if not has_color and #attr_str > 0 then
          table.insert(items, {
            name = name,
            type = 'attr',
            hex = '-',
            rgb = '-',
            attrs = attr_str,
          })
        end
      end
    end

    table.sort(items, function(a, b)
      if a.name == b.name then
        return a.type < b.type
      end
      return a.name < b.name
    end)

    local telescope_ok, entry_display =
      pcall(require, 'telescope.pickers.entry_display')
    if telescope_ok then
      local displayer = entry_display.create {
        separator = ' │ ',
        items = {
          { width = max_name_width },
          { width = 4 },
          { width = 9 },
          { width = 18 },
          { remaining = true },
        },
      }

      local entries = {}
      for _, item in ipairs(items) do
        local ordinal_str = string.format(
          '%s %s %s %s %s',
          item.name,
          item.type,
          item.hex,
          item.rgb,
          item.attrs
        )
        table.insert(entries, {
          ordinal = ordinal_str,
          value = item,
          display = function(entry)
            return displayer {
              { entry.value.name, entry.value.name },
              entry.value.type,
              entry.value.hex,
              entry.value.rgb,
              entry.value.attrs,
            }
          end,
        })
      end

      local source = {
        name = 'Highlights (telescope)',
        fn = function(_, process)
          process(entries)
        end,
      }
      local chosen = pick.start { source = source }
      if chosen == nil then
        return
      end
      return pick.registry[chosen]()
    end

    for _, item in ipairs(items) do
      local name_text =
        pad_right(ensure_text_width(item.name, max_name_width), max_name_width)
      item.text = string.format(
        '%s │ %-4s │ %-9s │ %-18s │ %s',
        name_text,
        item.type,
        item.hex or '-',
        item.rgb or '-',
        item.attrs or ''
      )
    end

    local source = {
      items = items,
      name = 'Highlights (%s)',
      choose = function() end,
    }
    local chosen = pick.start { source = source }
    if chosen == nil then
      return
    end
    return pick.registry[chosen]()
  end
end

return M
