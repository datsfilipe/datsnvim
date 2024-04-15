local config = require 'core.config'
local function isFileTooBig(bufnr)
  local max_filesize = 30 * 1024 -- 30KB
  local check_stats = (vim.uv or vim.loop).fs_stat
  local ok, stats = pcall(check_stats, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size > max_filesize then
    return true
  else
    return false
  end
end

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  config = function()
    local cmp = require 'cmp'

    local function format(entry, item)
      item.abbr = string.sub(item.abbr, 1, 40)
      item.kind = string.format('%s', config.kind[item.kind])
      item.menu = ({
        nvim_lsp = '(lsp)',
        luasnip = '(snp)',
        path = '(pth)',
        buffer = '(buf)',
      })[entry.source.name]

      return item
    end

    vim.api.nvim_create_autocmd('BufRead', {
      group = vim.api.nvim_create_augroup(
        'CmpBufferDisableGrp',
        { clear = true }
      ),
      callback = function(ev)
        local sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }
        local performance = {}

        if not isFileTooBig(ev.buf) then
          sources[#sources + 1] = { name = 'buffer', keyword_length = 4 }
          performance.max_view_entries = 10
        end
        cmp.setup.buffer {
          sources = cmp.config.sources(sources),
          performance = performance,
        }
      end,
    })

    cmp.setup {
      preselect = 'item',
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
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
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
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
      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer', keyword_length = 4 },
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = format,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      experimental = {
        ghost_text = false,
      },
    }

    cmp.event:on('menu_opened', function()
      vim.b.copilot_suggestion_hidden = true
    end)

    cmp.event:on('menu_closed', function()
      vim.b.copilot_suggestion_hidden = false
    end)
  end,
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },
}
