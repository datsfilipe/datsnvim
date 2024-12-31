return {
    {
        'ibhagwan/fzf-lua',
        cmd = 'FzfLua',
        keys = {
            {
                ';b',
                function()
                    require('fzf-lua').lgrep_curbuf {
                        winopts = {
                            preview = { vertical = 'up:70%' },
                        },
                    }
                end,
                desc = 'Grep current buffer',
            },
            { ';f', '<cmd>FzfLua files<cr>', desc = 'Find files' },
            { ';r', '<cmd>FzfLua live_grep_glob<cr>', desc = 'Grep' },
            {
                ';o',
                function()
                    vim.cmd 'rshada!'
                    require('fzf-lua').oldfiles()
                end,
                desc = 'Recently opened files',
            },
            { 'z=', '<cmd>FzfLua spell_suggest<cr>', desc = 'Spelling suggestions' },
        },
        opts = function()
            local actions = require 'fzf-lua.actions'

            return {
                -- Make stuff better combine with the editor.
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
                },
                keymap = {
                    builtin = {
                        ['<Tab>'] = 'toggle-preview',
                    },
                    fzf = {
                        ['alt-s'] = 'toggle',
                        ['alt-a'] = 'toggle-all',
                    },
                },
                winopts = {
                      border = 'none',
                      backdrop = 90,
                    preview = {
                      border = 'none',
                        scrollbar = false,
                        layout = 'vertical',
                        vertical = 'up:40%',
                    },
                },
                global_git_icons = false,
                -- Configuration for specific commands.
                files = {
                    winopts = {
                        preview = { hidden = 'hidden' },
                    },
                },
                grep = {
                    header_prefix = '? ',
                },
                helptags = {
                    actions = {
                        ['enter'] = actions.help_vert,
                    },
                },
                lsp = {
                    symbols = {
                        symbol_icons = require('icons').symbol_kinds,
                    },
                },
                oldfiles = {
                    include_current_session = true,
                    winopts = {
                        preview = { hidden = 'hidden' },
                    },
                },
            }
        end,
    },
}
