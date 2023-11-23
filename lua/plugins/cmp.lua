local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

cmp.event:on("menu_opened", function()
  vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
  vim.b.copilot_suggestion_hidden = false
end)

local cmp_format = require('lsp-zero').cmp_format()

local function border(hl_name)
  return {
    { '╭', hl_name },
    { '─', hl_name },
    { '╮', hl_name },
    { '│', hl_name },
    { '╯', hl_name },
    { '─', hl_name },
    { '╰', hl_name },
    { '│', hl_name },
  }
end

local cmp_window = require 'cmp.utils.window'

cmp_window.info_ = cmp_window.info
cmp_window.info = function(self)
  local info = self:info_()
  info.scrollable = false
  return info
end

cmp.setup {
  preselect = "item",
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = require "core.keymaps.integrations.cmp",
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "buffer", keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
    { name = "path", keyword_length = 2 },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = cmp_format,
  window = {
    completion = {
      border = border 'CmpBorder',
      winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None,FloatBorder:None',
    },
    documentation = {
      border = border 'CmpDocBorder',
      winhighlight = 'Normal:CmpDocPmenu,CursorLine:CmpDocPmenuSel,Search:None,FloatBorder:None',
    },
  },
}

vim.cmd[[
  set completeopt=menuone,noinsert,noselect
  set pumblend=0
  highlight! default link CmpItemKind CmpItemMenuDefault
  highlight CmpBorder guibg=NONE
  highlight CmpPmenu guibg=NONE
  highlight CmpDocBorder guibg=NONE
  highlight CmpDocPmenu guibg=NONE
]]
