vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }

-- don't show the dumb matching stuff
vim.opt.shortmess:append 'c'

local ok, lspkind = pcall(require, 'lspkind')
if not ok then
  return
end

local ok2, cmp = pcall(require, 'cmp')
if not ok2 then
  return
end

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
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i' }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      { 'i' }
    ),
    ['<C-CR>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { 'i' }
    ),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'copilot' },
  }, {
    { name = 'path' },
    { name = 'buffer', keyword_length = 5 },
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = lspkind.cmp_format {
      with_text = false,
      maxwidth = 50,
      menu = {
        buffer = '[バフ]', -- buff from buffer
        nvim_lsp = '[言語]', -- language
        luasnip = '[短い]', -- short from shortcut
        path = '[方法]', -- way
        copilot = '[完了]', -- completion
      },
    },
  },
  window = {
    completion = {
      border = border 'CmpBorder',
      winhighlight = 'Normal:Pmenu,CursorLine:PmenuSel,Search:None,FloatBorder:Pmenu',
    },
    documentation = {
      border = border 'CmpDocBorder',
      winhighlight = 'Normal:Pmenu,CursorLine:PmenuSel,Search:None,FloatBorder:Pmenu',
    },
  },
}
