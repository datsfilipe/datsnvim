local M = {}

local registry = {}
local registry_list = {}
local loaded = {}
local augroup =
  vim.api.nvim_create_augroup('UserManualLoader', { clear = true })
local transparency_cb = nil

local function do_after(mod)
  if mod.after == 'apply_transparency' and transparency_cb then
    transparency_cb()
  elseif type(mod.after) == 'function' then
    local ok, err = pcall(mod.after)
    if not ok then
      vim.notify(err, vim.log.levels.WARN)
    end
  end
end

local function load(name)
  if loaded[name] then
    return true
  end

  local entry = registry[name]
  if not entry then
    return nil
  end

  local mod = entry.mod

  if type(mod.setup) == 'function' then
    local ok, err = pcall(mod.setup)
    if not ok then
      vim.notify(
        string.format('failed to setup %s: %s', name, err),
        vim.log.levels.ERROR
      )
      return nil
    end
  end

  do_after(mod)

  loaded[name] = true
  return true
end

local function map_keys(name, keys)
  for _, key in ipairs(keys) do
    local mode, lhs, action, desc = key[1], key[2], key[3], key[4]
    vim.keymap.set(mode, lhs, function()
      load(name)
      if type(action) == 'function' then
        action()
      elseif type(action) == 'string' and action ~= '' then
        local key_code =
          vim.api.nvim_replace_termcodes(action, true, true, true)
        vim.api.nvim_feedkeys(key_code, 'n', false)
      end
    end, { desc = desc, silent = true })
  end
end

local function map_commands(name, commands)
  for _, command in ipairs(commands) do
    local cmd_name, action, opts = command[1], command[2], command[3]
    vim.api.nvim_create_user_command(cmd_name, function(cmd_opts)
      load(name)
      if type(action) == 'function' then
        action(cmd_opts)
      elseif type(action) == 'string' and action ~= '' then
        vim.cmd(action)
      end
    end, opts or {})
  end
end

local function register_event(name, mod)
  vim.api.nvim_create_autocmd(mod.event, {
    group = augroup,
    pattern = mod.pattern,
    once = mod.once,
    callback = function()
      load(name)
    end,
  })
end

function M.setup(opts)
  registry_list = {
    { name = 'colorschemes', module = 'user.plugins.colorschemes' },
    { name = 'statusline', module = 'user.modules.statusline' },
    { name = 'tabline', module = 'user.modules.tabline' },
    { name = 'quickfix', module = 'user.modules.quickfix' },
    { name = 'discipline', module = 'user.modules.discipline' },
    { name = 'markdown', module = 'user.modules.markdown' },
    { name = 'completion', module = 'user.modules.completion' },
    { name = 'treesitter', module = 'user.plugins.treesitter' },
    { name = 'indentmini', module = 'user.plugins.indentmini' },
    { name = 'lspconfig', module = 'user.plugins.lspconfig' },
    { name = 'fidget', module = 'user.plugins.fidget' },
    { name = 'fzf-lua', module = 'user.plugins.fzf-lua' },
    { name = 'minidiff', module = 'user.plugins.minidiff' },
    { name = 'console', module = 'user.plugins.console' },
    { name = 'oil', module = 'user.plugins.oil' },
    { name = 'tools', module = 'user.modules.tools' },
  }

  registry = {}

  for _, entry in ipairs(registry_list) do
    local ok, mod = pcall(require, entry.module)

    if ok and type(mod) == 'table' then
      entry.mod = mod
      registry[entry.name] = entry

      if mod.keys then
        map_keys(entry.name, mod.keys)
      end

      if mod.commands then
        map_commands(entry.name, mod.commands)
      end

      if mod.event then
        register_event(entry.name, mod)
      end

      local is_lazy = (mod.keys or mod.commands or mod.event)
      if mod.ensure or not is_lazy then
        load(entry.name)
      end

      if mod.apply_transparency then
        transparency_cb = mod.apply_transparency
      end
    else
      vim.notify(
        string.format('failed to read config from %s', entry.module),
        vim.log.levels.WARN
      )
    end
  end

  M._registry = registry_list
  M._loaded = loaded
end

M.load = load

return M
