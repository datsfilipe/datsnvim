local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end
vim.opt.rtp = vim.opt.rtp ^ lazypath

local function get_plugin_specs()
  local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
  local plugin_files = {}
  
  local handle = vim.loop.fs_scandir(plugins_dir)
  if handle then
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then break end
      
      if type == "file" and name:match("%.lua$") and name ~= "init.lua" then
        local module_name = name:gsub("%.lua$", "")
        table.insert(plugin_files, { import = 'plugins.' .. module_name })
      end
    end
  end

  return {
    spec = plugin_files
  }
end

---@type LazySpec
local plugins = get_plugin_specs()

require('lazy').setup({
    spec = plugins.spec,
    dev = { path = vim.g.projects_dir },
    defaults = {
      lazy = true,
    },
    install = {
        missing = false,
    },
    change_detection = { notify = false },
    rocks = {
        enabled = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip',
                'netrwPlugin',
                'netrw',
                'matchit',
                'matchparen',
                'vimball',
                'vimballPlugin',
                'rplugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
    ui = {
      border = 'none',
      backdrop = 90,
      icons = {
        cmd = '[cmd]',
        config = '[conf]',
        event = '[evnt]',
        favorite = '[fav]',
        ft = '[ft]',
        init = '[init]',
        import = '[imp]',
        keys = '[key]',
        lazy = '[#]',
        loaded = '[x]',
        not_loaded = '[ ]',
        plugin = '[plug]',
        runtime = '[runtime]',
        require = '[req]',
        source = '[src]',
        start = '[start]',
        task = '[done]',
        list = {
          '*',
          '->',
          '+',
          '-',
        },
      },
    },
})
