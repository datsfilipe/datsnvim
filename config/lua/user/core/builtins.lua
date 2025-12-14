local to_be_disabled = {
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'matchit',
  'tar',
  'tarPlugin',
  'rrhelper',
  'spellfile_plugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
  'tutor_mode_plugin',
  'rplugin',
  'syntax_completion',
  'synmenu',
  'optwin',
  'compiler',
  'bugreport',
  'ftplugin',
  'python3_provider',
  'ruby_provider',
  'perl_provider',
  'node_provider',
}

for _, plugin in ipairs(to_be_disabled) do
  vim.g['loaded_' .. plugin] = 1
end
vim.g.loaded_netrw_banner = 1

vim.cmd.packadd 'nvim.difftool'
vim.cmd.packadd 'nvim.undotree'
