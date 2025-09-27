-- local function pkg_dir(name)
--   return vim.api.nvim_get_runtime_file('pack/*/start/' .. name, true)[1]
-- end
--
-- require('lazy').setup {
--   defaults = {
--     lazy = true,
--   },
--   install = {
--     colorscheme = { 'vesper' },
--     missing = false,
--   },
--   change_detection = { notify = false },
--   rocks = {
--     enabled = false,
--   },
--   performance = {
--     rtp = {
--       disabled_plugins = {
--         'gzip',
--         'matchparen',
--         'vimball',
--         'vimballPlugin',
--         'rplugin',
--         'tarPlugin',
--         'tohtml',
--         'tutor',
--         'zipPlugin',
--         '2html_plugin',
--         'getscript',
--         'getscriptPlugin',
--         'logipat',
--         'netrw',
--         'netrwPlugin',
--         'netrwSettings',
--         'netrwFileHandlers',
--         'matchit',
--         'tar',
--         'rrhelper',
--         'spellfile_plugin',
--         'zip',
--         'tutor_mode_plugin',
--         'syntax_completion',
--         'synmenu',
--         'optwin',
--         'compiler',
--         'bugreport',
--         'ftplugin',
--       },
--     },
--   },
--   ui = {
--     border = 'none',
--     backdrop = 90,
--     icons = require('icons').lazy_icons,
--   },
-- }

require 'plugins.colorschemes'
require 'plugins.treesitter'
require 'plugins.conform'
require 'plugins.indentmini'
require 'plugins.lspconfig'
require 'plugins.oil'
require 'plugins.fidget'
require 'plugins.supermaven'
require 'plugins.minidiff'
require 'plugins.nvim_lint'
require 'plugins.minipick'
