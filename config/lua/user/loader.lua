local M = {}

local registry = {}
local registry_list = {}
local loaded = {}
local augroup =
  vim.api.nvim_create_augroup('UserManualLoader', { clear = true })

local function do_after(entry)
  if type(entry.after) == 'function' then
    local ok, err = pcall(entry.after)
    if not ok then
      vim.notify(err, vim.log.levels.WARN)
    end
  end
end

local function load(name)
  if loaded[name] then
    return loaded[name]
  end

  local entry = registry[name]
  if not entry then
    return nil
  end

  local ok, mod = pcall(require, entry.module)
  if not ok then
    vim.notify(
      string.format('Failed to load %s: %s', entry.module, mod),
      vim.log.levels.ERROR
    )
    return nil
  end

  if type(mod.setup) == 'function' then
    mod.setup(entry.opts or {})
  end

  do_after(entry)

  loaded[name] = mod or true
  return loaded[name]
end

local function map_keys(entry)
  for _, key in ipairs(entry.keys) do
    local mode, lhs, action, desc = key[1], key[2], key[3], key[4]
    vim.keymap.set(mode, lhs, function()
      load(entry.name)
      if type(action) == 'function' then
        action()
      elseif type(action) == 'string' and action ~= '' then
        vim.cmd(action)
      end
    end, { desc = desc, silent = true })
  end
end

local function map_commands(entry)
  for _, command in ipairs(entry.commands) do
    local name, action, opts = command[1], command[2], command[3]
    vim.api.nvim_create_user_command(name, function(cmd_opts)
      load(entry.name)
      if type(action) == 'function' then
        action(cmd_opts)
      elseif type(action) == 'string' and action ~= '' then
        vim.cmd(action)
      end
    end, opts or {})
  end
end

local function register_event(entry)
  vim.api.nvim_create_autocmd(entry.event, {
    group = augroup,
    pattern = entry.pattern,
    once = entry.once,
    callback = function()
      load(entry.name)
    end,
  })
end

function M.setup(opts)
  local apply_transparency = opts and opts.apply_transparency

  registry_list = {
    { name = 'statusline', module = 'user.modules.statusline' },
    { name = 'tabline', module = 'user.modules.tabline' },
    {
      name = 'quickfix',
      module = 'user.modules.quickfix',
      event = 'VimEnter',
    },
    {
      name = 'discipline',
      module = 'user.modules.discipline',
      event = 'VimEnter',
    },
    { name = 'markdown', module = 'user.modules.markdown', event = 'VimEnter' },
    {
      name = 'completion',
      module = 'user.modules.completion',
      event = 'LspAttach',
    },
    { name = 'console', module = 'user.modules.console' },
    {
      name = 'treesitter',
      module = 'user.plugins.treesitter',
      event = { 'BufReadPre', 'BufNewFile' },
    },
    {
      name = 'indentmini',
      module = 'user.plugins.indentmini',
      event = { 'BufReadPre', 'BufNewFile' },
      after = apply_transparency,
    },
    {
      name = 'conform',
      module = 'user.plugins.conform',
      event = 'VimEnter',
      once = true,
    },
    {
      name = 'nvim_lint',
      module = 'user.plugins.nvim_lint',
      event = 'VimEnter',
      once = true,
    },
    {
      name = 'lspconfig',
      module = 'user.plugins.lspconfig',
      event = 'VimEnter',
      once = true,
    },
    {
      name = 'fidget',
      module = 'user.plugins.fidget',
      event = 'LspAttach',
    },
    {
      name = 'supermaven',
      module = 'user.plugins.supermaven',
      event = 'InsertEnter',
      once = true,
    },
    {
      name = 'minidiff',
      module = 'user.plugins.minidiff',
      event = 'BufReadPost',
      once = true,
    },
    {
      name = 'oil',
      module = 'user.plugins.oil',
      keys = {
        { 'n', '<leader>e', 'Oil', 'file explorer' },
      },
      after = apply_transparency,
      ensure = true,
    },
    {
      name = 'minipick',
      module = 'user.plugins.minipick',
      keys = {
        { 'n', ';f', 'Pick files', 'files' },
        { 'n', ';r', 'Pick grep_live', 'grep' },
        { 'n', ';k', 'Pick keymaps', 'keymaps' },
        { 'n', ';h', 'Pick highlights', 'highlights' },
        { 'n', '\\\\', 'Pick buffers', 'search buffers' },
      },
      after = apply_transparency,
    },
  }

  registry = {}
  for _, entry in ipairs(registry_list) do
    registry[entry.name] = entry

    if entry.keys then
      map_keys(entry)
    end
    if entry.commands then
      map_commands(entry)
    end
    if entry.event then
      register_event(entry)
    end
  end

  for _, entry in ipairs(registry_list) do
    if
      entry.ensure
      or (not entry.event and not entry.keys and not entry.commands)
    then
      load(entry.name)
    end
  end

  M._registry = registry_list
  M._loaded = loaded
end

M.load = load

return M
