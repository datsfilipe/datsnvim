local kind_icons = require "utils.config".kind

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  config = function()
    local cmp = require "cmp"
    local cmp_window = require 'cmp.utils.window'

    cmp.event:on("menu_opened", function()
      vim.b.copilot_suggestion_hidden = true
    end)
    cmp.event:on("menu_closed", function()
      vim.b.copilot_suggestion_hidden = false
    end)

    cmp_window.info_ = cmp_window.info
    cmp_window.info = function(self)
      local info = self:info_()
      info.scrollable = false
      return info
    end

    local function border(hl_name)
      return {
        { '╭', hl_name }, { '─', hl_name }, { '╮', hl_name },
        { '│', hl_name }, { '╯', hl_name }, { '─', hl_name },
        { '╰', hl_name }, { '│', hl_name },
      }
    end

    cmp.setup {
      preselect = "item",
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i" }),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-u>"] = cmp.mapping.scroll_docs(4),
        -- ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping(
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          },
          { "i" }
        ),
        ["<C-CR>"] = cmp.mapping(
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
          { "i" }
        ),
      },
      sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "buffer",  keyword_length = 3 },
        { name = "luasnip", keyword_length = 2 },
        { name = "path",    keyword_length = 2 },
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
          item.abbr = string.sub(item.abbr, 1, 40)
          item.kind = string.format("%s", kind_icons[item.kind])
          -- item.kind = string.format("%s %s", kind_icons[item.kind], item.kind) -- debug

          item.menu = ({
            nvim_lsp = "[言語]", -- language
            luasnip = "[短い]", -- short from shortcut
            buffer = "[バフ]", -- buff from buffer
            path = "[方法]", -- way
          })[entry.source.name]

          return item
        end,
      },
      window = {
        completion = {
          border = border 'CmpBorder',
          winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None,FloatBorder:None',
        },
        documentation = {
          border = border 'CmpDocBorder',
          winhighlight = 'Normal:CmpDocPmenu,CursorLine:CmpDocPmenuSel,Search:None,FloatBorder:None',
        },
      }
    }
  end,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
}
