local function generate_spec()
  local plugins_dir = vim.fn.stdpath 'config' .. '/lua/plugins'
  local plugins = {}

  for name, type in vim.fs.dir(plugins_dir) do
    if
      (type == 'file' or type == 'link')
      and name:match '%.lua$'
      and name ~= 'init.lua'
    then
      local module_name = 'plugins.' .. name:gsub('%.lua$', '')
      table.insert(plugins, { import = module_name })
    elseif type == 'directory' then
      local init_path = plugins_dir .. '/' .. name .. '/init.lua'
      if vim.loop.fs_stat(init_path) then
        local module_name = 'plugins.' .. name
        table.insert(plugins, { import = module_name .. '.init' })
      end
    end
  end

  local extras = {
    { import = 'extras' },
  }

  return { spec = vim.list_extend(plugins, extras) }
end

return generate_spec()
