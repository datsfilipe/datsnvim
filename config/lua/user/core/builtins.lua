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
}

for _, plugin in pairs(to_be_disabled) do
  vim.g['loaded_' .. plugin] = 1
end
