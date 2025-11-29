local M = {}

function M.setup()
  if M._loaded then
    return
  end
  M._loaded = true

  local ok, pick = pcall(require, 'mini.pick')
  if not ok then
    return
  end

  local highlights = require 'user.modules.pickers.highlights'
  local keymaps = require 'user.modules.pickers.keymaps'

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
    },
  }

  keymaps.setup(pick)
  highlights.setup(pick)

  -- override vim.paste to work with mini pick; ref: https://github.com/nvim-mini/mini.nvim/discussions/1263#discussioncomment-11860457
  local original_paste = vim.paste
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.paste = function(...)
    if not pick.is_picker_active() then
      return original_paste(...)
    end

    for _, reg in ipairs { '+', '.', '*' } do
      local content = vim.fn.getreg(reg) or ''

      content = content:gsub('[\n\r]+', ' ')
      content = vim.trim(content)

      if content ~= '' then
        pick.set_picker_query { content }
        return
      end
    end
  end
end

return M
