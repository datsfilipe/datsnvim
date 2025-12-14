local providers = {
  'python3_provider',
  'ruby_provider',
  'perl_provider',
  'node_provider',
}

for i = 1, #providers do
  vim.g['loaded_' .. providers[i]] = 0
end

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

for i = 1, #to_be_disabled do
  vim.g['loaded_' .. to_be_disabled[i]] = 1
end

vim.g.netrw_banner = 0

vim.cmd.packadd 'nvim.difftool'
vim.cmd.packadd 'nvim.undotree'
