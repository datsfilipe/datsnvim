local ok, alpha = pcall(require, 'alpha')
if not ok then
  return
end

local dashboard = require('alpha.themes.dashboard')

-- set header
dashboard.section.header.val = {
  '                                       ',
  '               ░░▒▒        ▒▒          ',
  '           ▒▒                  ▒▒      ',
  '                                 ▒▒    ',
  '       ░░                          ▓▓  ',
  '                                       ',
  '     ▒▒                                ',
  '     ░░        ▒▒▒▒                    ',
  '     ░░██      ████████                ',
  '   ████████    ██████████  ██          ',
  '   ████████    ██████████  ████        ',
  '   ░░████░░░░  ████████▓▓  ░░        ░░',
  '   ░░  ░░  ██    ░░░░░░        ▒▒      ',
  '   ▒▒░░    ████        ░░░░        ░░  ',
  '   ▒▒░░    ████          ░░            ',
  '   ░░██░░  ░░▒▒  ▒▒  ░░        ░░▒▒    ',
  '       ░░░░░░▒▒▒▒░░░░████▓▓▒▒  ░░      ',
  '       ████▒▒  ░░▒▒██████░░            ',
  '       ██████▒▒▒▒████  ██              ',
  '       ██▒▒░░░░░░    ▒▒                ',
  '       ░░  ▓▓            ██            ',
  '       ██            ▒▒                ',
  '                                       ',
}

-- set menu
dashboard.section.buttons.val = {
  dashboard.button( 'f', '  > Find file', ':cd $HOME/Workspace | Telescope find_files<CR>'),
  dashboard.button( 's', '  > Settings' , ':e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>'),
  dashboard.button( 'q', '  > Quit NVIM', ':qa<CR>'),
}

alpha.setup(dashboard.opts)

-- disable folding on alpha buffer
vim.cmd([[
  autocmd FileType alpha setlocal nofoldenable
]])
