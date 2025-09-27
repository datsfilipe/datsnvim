local ok, pick = pcall(require, 'mini.pick')
if not ok then
  return
end

local highlights = require 'extensions.pickers.highlights'
local keymaps = require 'extensions.pickers.keymaps'

pick.setup {
  delay = {
    async = 10,
    busy = 50,
  },
  mappings = {
    toggle_preview = '<Tab>',
    choose_all = {
      char = '<C-l>',
      func = function()
        local mappings = pick.get_picker_opts().mappings
        vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
      end,
    },
    scroll_right = '<C-f>',
    scroll_left = '<C-b>',
  },
  options = {
    content_from_bottom = false,
    use_cache = true,
  },
  window = {
    config = {
      border = 'none',
    },
    prompt_caret = '█',
    prompt_prefix = '検索 ',
  },
  source = {
    show = pick.default_show,
    -- TODO: fix this issue
    -- with my current setup, icons are not reflected properly the window, so I'm just hiding them for now
    -- show = function(buf_id, items, query)
    --   return pick.default_show(buf_id, items, query, {
    --     show_icons = true,
    --     icons = { directory = '| ./ | ', file = '| .* | ' },
    --   })
    -- end,
  },
}

keymaps.setup(pick)
highlights.setup(pick)

vim.keymap.set('n', ';f', '<cmd>Pick files<cr>', { desc = 'files' })
vim.keymap.set('n', ';r', '<cmd>Pick grep_live<cr>', { desc = 'grep' })
vim.keymap.set('n', ';k', '<cmd>Pick keymaps<cr>', { desc = 'keymaps' })
vim.keymap.set('n', ';h', '<cmd>Pick highlights<cr>', { desc = 'highlights' })
vim.keymap.set(
  'n',
  '\\\\',
  '<cmd>Pick buffers<cr>',
  { desc = 'search buffers' }
)

-- override vim.paste to work with mini pick; ref: https://github.com/nvim-mini/mini.nvim/discussions/1263#discussioncomment-11860457
local original_paste = vim.paste
---@diagnostic disable-next-line: duplicate-set-field
vim.paste = function(...)
  if not pick.is_picker_active() then
    return original_paste(...)
  end

  for _, reg in ipairs { '+', '.', '*' } do
    local content = vim.fn.getreg(reg) or ''

    if content ~= '' then
      pick.set_picker_query { content }
      return
    end
  end
end
