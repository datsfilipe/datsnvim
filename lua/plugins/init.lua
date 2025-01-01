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

local function load_plugin_spec(module_path)
    local ok, spec = pcall(require, module_path)
    if not ok then
        print("error loading module:", module_path, spec)
        return nil
    end

    if type(spec) ~= "table" then return nil end
    if spec[1] or spec.name or spec.url or spec.dir then
        return spec
    else
        return nil
    end
end

local function get_plugin_specs()
    local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
    local plugin_specs = {}

    for name, type in vim.fs.dir(plugins_dir) do
        local module_name
        if type == "file" and name:match("%.lua$") and name ~= "init.lua" then
            module_name = "plugins." .. name:gsub("%.lua$", "")
        elseif type == "directory" then
            local init_path = plugins_dir .. "/" .. name .. "/init.lua"
            if vim.loop.fs_stat(init_path) then
                module_name = "plugins." .. name
            end
        end

        if module_name then
            local spec = load_plugin_spec(module_name)
            if spec then
                table.insert(plugin_specs, spec)
            end
        end
    end

    return { spec = plugin_specs }
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
      icons = require('icons').lazy_icons,
    },
})
