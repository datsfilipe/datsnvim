local icons = require 'user.icons'
local utils = require 'user.utils'
local map = utils.map
local opts = utils.map_options

map('n', ';B', function()
  require('fzf-lua').lgrep_curbuf {
    winopts = {
      height = 0.6,
      width = 0.5,
    },
    fzf_opts = { ['--layout'] = 'reverse' },
  }
end, vim.tbl_extend('force', opts, { desc = 'search buffer' }))

map('x', ';B', function()
  require('fzf-lua').blines {
    winopts = {
      height = 0.6,
      width = 0.5,
    },
    fzf_opts = { ['--layout'] = 'reverse' },
  }
end, vim.tbl_extend('force', opts, { desc = 'search buffer (visual)' }))

map('n', ';b', '<cmd>FzfLua buffers<cr>', { desc = 'buffers' })
map('n', ';h', '<cmd>FzfLua highlights<cr>', { desc = 'highlights' })
map('n', ';H', '<cmd>FzfLua help_tags<cr>', { desc = 'help' })
map(
  'n',
  ';d',
  '<cmd>FzfLua lsp_document_diagnostics<cr>',
  { desc = 'diagnostics' }
)
map('n', ';f', '<cmd>FzfLua files<cr>', { desc = 'files' })
map('n', ';F', '<cmd>FzfLua oldfiles<cr>', { desc = 'opened files' })
map('n', ';r', '<cmd>FzfLua live_grep<cr>', { desc = 'grep' })
map('n', 'z=', '<cmd>FzfLua spell_suggest<cr>', { desc = 'spell suggestions' })

local actions = require 'fzf-lua.actions'

---@diagnostic disable-next-line duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  local ui_select = require 'fzf-lua.providers.ui_select'
  if not ui_select.is_registered() then
    ui_select.register(function(ui_opts)
      if ui_opts.kind == 'color_presentation' then
        ui_opts.winopts = { relative = 'cursor', height = 0.35, width = 0.3 }
      else
        ui_opts.winopts = { height = 0.5, width = 0.4 }
      end
      if ui_opts.kind then
        ui_opts.winopts.title = string.format(' %s ', ui_opts.kind)
      end
      if ui_opts.prompt and not vim.endswith(ui_opts.prompt, ' ') then
        ui_opts.prompt = ui_opts.prompt .. ' '
      end
      return ui_opts
    end)
  end
  if #items > 0 then
    return vim.ui.select(items, opts, on_choice)
  end
end

require('fzf-lua').setup {
  { 'ivy', 'borderless', 'hide', 'max-perf' },
  fzf_colors = {
    bg = { 'bg', 'Normal' },
    gutter = { 'bg', 'Normal' },
    info = { 'fg', 'Conditional' },
    scrollbar = { 'bg', 'Normal' },
    separator = { 'fg', 'Comment' },
  },
  fzf_opts = {
    ['--info'] = 'default',
    ['--layout'] = 'reverse-list',
    ['--border'] = 'none',
  },
  keymap = {
    builtin = {
      ['<C-a>'] = 'toggle-fullscreen',
    },
    fzf = {
      ['ctrl-l'] = 'select-all+accept',
    },
  },
  winopts = {
    height = 0.7,
    width = 0.55,
    preview = { hidden = true },
  },
  defaults = { git_icons = false },
  grep = {
    hidden = true,
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!.git" -e',
    fzf_opts = { ['--ansi'] = true },
    rg_glob_fn = function(query, opts)
      local regex, flags =
        query:match(string.format('^(.*)%s(.*)$', opts.glob_separator))
      return (regex or query), flags
    end,
  },
  helptags = {
    actions = {
      ['enter'] = actions.help_vert,
    },
  },
  lsp = {
    code_actions = {
      winopts = {
        width = 70,
        height = 20,
        relative = 'cursor',
        preview = {
          hidden = true,
          vertical = 'down:50%',
        },
      },
    },
  },
  diagnostics = {
    multiline = 1,
    diag_icons = {
      icons.diagnostics.ERROR,
      icons.diagnostics.WARN,
      icons.diagnostics.INFO,
      icons.diagnostics.HINT,
    },
  },
  oldfiles = {
    include_current_session = true,
    winopts = {
      preview = { hidden = true },
    },
  },
}
