local M = {}
local settings = require 'user.settings'

local core_plugins = {
  { name = 'nvim-lspconfig', src = 'https://github.com/neovim/nvim-lspconfig' },
  { name = 'conform.nvim', src = 'https://github.com/stevearc/conform.nvim' },
  { name = 'nvim-lint', src = 'https://github.com/mfussenegger/nvim-lint' },
  { name = 'nvim-treesitter', src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { name = 'mini.pick', src = 'https://github.com/echasnovski/mini.pick' },
  { name = 'mini.diff', src = 'https://github.com/echasnovski/mini.diff' },
  { name = 'oil.nvim', src = 'https://github.com/stevearc/oil.nvim' },
  { name = 'indentmini.nvim', src = 'https://github.com/nvimdev/indentmini.nvim' },
  { name = 'supermaven-nvim', src = 'https://github.com/supermaven-inc/supermaven-nvim' },
  { name = 'fidget.nvim', src = 'https://github.com/j-hui/fidget.nvim' },
  { name = 'vim-wakatime', src = 'https://github.com/wakatime/vim-wakatime' },
}

local theme_plugins = {
  ['catppuccin'] = { name = 'catppuccin', src = 'https://github.com/catppuccin/nvim' },
  ['kanagawa'] = { name = 'kanagawa', src = 'https://github.com/rebelot/kanagawa.nvim' },
  ['gruvbox'] = { name = 'gruvbox', src = 'https://github.com/datsfilipe/gruvbox.nvim' },
  ['min-theme'] = { name = 'min-theme', src = 'https://github.com/datsfilipe/min-theme.nvim' },
  ['vesper'] = { name = 'vesper', src = 'https://github.com/datsfilipe/vesper.nvim' },
}

local function ensure_packpath()
  local data_site = vim.fs.joinpath(vim.fn.stdpath 'data', 'site')
  if not vim.o.packpath:find(vim.pesc(data_site), 1, true) then
    vim.opt.packpath:prepend(data_site)
  end
end

local function resolve_theme_plugin(theme_name)
  local normalized = (theme_name or ''):lower()
  if normalized:find 'catppuccin' then
    return 'catppuccin'
  end
  if normalized:find 'kanagawa' then
    return 'kanagawa'
  end
  if normalized:find 'gruvbox' then
    return 'gruvbox'
  end
  if normalized:find 'vesper' then
    return 'vesper'
  end
  if normalized:find 'min' then
    return 'min-theme'
  end
  return 'catppuccin'
end

local function build_specs(active_theme)
  local specs = {}
  local function add(entry)
    if entry.enabled == false then
      return
    end
    specs[#specs + 1] = {
      src = entry.src,
      name = entry.name,
      version = entry.version,
    }
  end

  for _, plugin in ipairs(core_plugins) do
    add(plugin)
  end

  local theme_plugin = theme_plugins[active_theme]
  if theme_plugin then
    add(theme_plugin)
  end

  return specs
end

function M.setup()
  if M._setup_done then
    return
  end
  M._setup_done = true

  if not vim.pack or type(vim.pack.add) ~= 'function' then
    return
  end

  ensure_packpath()

  local ok_theme, theme_mod = pcall(require, 'user.core.theme')
  local theme_name = ok_theme and theme_mod.current and theme_mod.current()
    or settings.get().theme
  local theme_key = resolve_theme_plugin(theme_name)
  local specs = build_specs(theme_key)

  if vim.tbl_isempty(specs) then
    return
  end

  local ok, err = pcall(vim.pack.add, specs, { confirm = false, load = true })
  if not ok then
    vim.notify('vim.pack failed: ' .. tostring(err), vim.log.levels.WARN)
  end
end

return M
