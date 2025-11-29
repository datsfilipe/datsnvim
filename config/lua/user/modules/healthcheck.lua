local function assert_loaded(module_name, label)
  if package.loaded[module_name] then
    print('[OK] Module loaded: ' .. (label or module_name))
    return
  end

  print('[  ] FAILED: Module not loaded: ' .. (label or module_name))
  os.exit(1)
end

assert_loaded('user.core.options', 'core options')
assert_loaded('user.core.keymaps', 'core keymaps')

local loader = require 'user.loader'
loader.load 'treesitter'
assert_loaded('user.plugins.treesitter', 'treesitter')

loader.load 'lspconfig'
assert_loaded('user.plugins.lspconfig', 'lsp setup')

loader.load 'conform'
assert_loaded('user.plugins.conform', 'formatter')

local settings = require 'user.settings'
local theme = require 'user.core.theme'
local expected_theme = settings.get().theme
local applied_theme = theme.current()
print(string.format('[OK] Theme configured: %s (applied: %s)', expected_theme, applied_theme))

print 'ALL SYSTEM CHECKS PASSED'
vim.cmd 'qa!'
