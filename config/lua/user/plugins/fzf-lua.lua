local icons = require 'user.icons'

return {
  keys = {
    {
      'n',
      ';b',
      function()
        local opts = {
          winopts = {
            height = 0.6,
            width = 0.5,
            preview = { vertical = 'up:60%' },
            treesitter = {
              enabled = false,
              fzf_colors = {
                ['fg'] = { 'fg', 'CursorLine' },
                ['bg'] = { 'bg', 'Normal' },
              },
            },
          },
          fzf_opts = { ['--layout'] = 'reverse' },
        }
        require('fzf-lua').lgrep_curbuf(opts)
      end,
      'search buffer',
    },
    {
      'x',
      ';b',
      function()
        local opts = {
          winopts = {
            height = 0.6,
            width = 0.5,
            preview = { vertical = 'up:60%' },
            treesitter = { enabled = false },
          },
          fzf_opts = { ['--layout'] = 'reverse' },
        }
        require('fzf-lua').blines(opts)
      end,
      'search buffer (visual)',
    },
    { 'n', ';B', '<cmd>FzfLua buffers<cr>', 'buffers' },
    { 'n', ';h', '<cmd>FzfLua highlights<cr>', 'highlights' },
    { 'n', ';H', '<cmd>FzfLua help_tags<cr>', 'help' },
    { 'n', ';d', '<cmd>FzfLua lsp_document_diagnostics<cr>', 'diagnostics' },
    { 'n', ';f', '<cmd>FzfLua files<cr>', 'files' },
    { 'n', ';F', '<cmd>FzfLua oldfiles<cr>', 'opened files' },
    { 'n', ';r', '<cmd>FzfLua live_grep<cr>', 'grep' },
    { 'n', 'z=', '<cmd>FzfLua spell_suggest<cr>', 'spell suggestions' },
  },
  setup = function()
    local actions = require 'fzf-lua.actions'

    ---@diagnostic disable-next-line duplicate-set-field
    vim.ui.select = function(items, opts, on_choice)
      local ui_select = require 'fzf-lua.providers.ui_select'
      if not ui_select.is_registered() then
        ui_select.register(function(ui_opts)
          if ui_opts.kind == 'color_presentation' then
            ui_opts.winopts =
              { relative = 'cursor', height = 0.35, width = 0.3 }
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
      previewers = {
        meow = { cmd = 'meow', args = nil },
      },
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
          ['<C-i>'] = 'toggle-preview',
        },
        fzf = {
          ['ctrl-i'] = 'toggle-preview',
        },
      },
      winopts = {
        height = 0.7,
        width = 0.55,
        preview = {
          hidden = true,
          scrollbar = false,
          layout = 'vertical',
          vertical = 'up:40%',
        },
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
  end,
}
