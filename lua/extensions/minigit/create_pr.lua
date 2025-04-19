local M = {}

M.config = {
  remotes = { 'fork', 'origin', 'upstream' },
  default_base = nil,
  browser_commands = {
    mac = 'open',
    unix = 'xdg-open',
    win = 'start',
  },
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

local function detect_remote()
  for _, remote in ipairs(M.config.remotes) do
    local ok = vim
      .system({ 'git', 'remote', 'get-url', remote }, { text = true })
      :wait()
    if ok.code == 0 then
      return remote
    end
  end
  return nil
end

local function parse_github_url(url)
  url = vim.trim(url)
  local owner, repo = url:match 'github%.com[:/]([^/]+)/([^%.]+)%.?g?i?t?$'
  return owner, repo
end

local function get_default_branch()
  if M.config.default_base then
    return M.config.default_base
  end

  local result = vim
    .system({
      'git',
      'remote',
      'show',
      'origin',
    }, { text = true })
    :wait()

  if result.code == 0 then
    local default = result.stdout:match 'HEAD branch: ([^\n]+)'
    return default or 'main'
  end
  return 'main'
end

local function select_base_branch(default_branch, callback)
  local result = vim
    .system({
      'git',
      'for-each-ref',
      'refs/remotes',
      '--format=%(refname:lstrip=3)',
    }, { text = true })
    :wait()

  if result.code ~= 0 then
    vim.notify('failed to get remote branches', vim.log.levels.ERROR)
    return
  end

  local branches = {}
  for branch in result.stdout:gmatch '[^\r\n]+' do
    if not branch:match 'HEAD' then
      branch = branch:gsub('^[^/]+/', '')
      table.insert(branches, branch)
    end
  end

  table.sort(branches, function(a, b)
    if a == default_branch then
      return true
    elseif b == default_branch then
      return false
    else
      return a < b
    end
  end)

  vim.ui.select(branches, {
    prompt = 'select base branch:',
    format_item = function(item)
      if item == default_branch then
        return item .. ' (default)'
      else
        return item
      end
    end,
  }, function(choice)
    if choice then
      callback(choice)
    end
  end)
end

local function open_browser(url)
  local cmd
  if vim.fn.has 'mac' == 1 then
    cmd = M.config.browser_commands.mac
  elseif vim.fn.has 'unix' == 1 then
    cmd = M.config.browser_commands.unix
  elseif vim.fn.has 'win32' == 1 then
    cmd = M.config.browser_commands.win
  else
    vim.notify('unsupported platform for opening browser', vim.log.levels.ERROR)
    vim.notify('PR URL: ' .. url, vim.log.levels.INFO)
    return
  end

  vim.system({ cmd, url }):wait()
end

function M.create_pull_request()
  local current_branch_result = vim
    .system({
      'git',
      'branch',
      '--show-current',
    }, { text = true })
    :wait()

  if current_branch_result.code ~= 0 then
    vim.notify('failed to determine current branch', vim.log.levels.ERROR)
    return
  end

  local current_branch = vim.trim(current_branch_result.stdout)
  local default_branch = get_default_branch()

  if current_branch == default_branch then
    vim.notify('cannot create PR from default branch', vim.log.levels.ERROR)
    return
  end

  local remote = detect_remote()
  if not remote then
    vim.notify('no valid remote found', vim.log.levels.ERROR)
    return
  end

  local origin_url_result = vim
    .system({
      'git',
      'remote',
      'get-url',
      'origin',
    }, { text = true })
    :wait()

  if origin_url_result.code ~= 0 then
    vim.notify('failed to get repository URL', vim.log.levels.ERROR)
    return
  end

  local origin_owner, origin_repo = parse_github_url(origin_url_result.stdout)
  if not origin_owner or not origin_repo then
    vim.notify('could not parse GitHub repository URL', vim.log.levels.ERROR)
    return
  end

  vim.notify('pushing to ' .. remote .. '...', vim.log.levels.INFO)
  local push_result = vim
    .system({
      'git',
      'push',
      '-u',
      remote,
      current_branch,
    })
    :wait()

  if push_result.code ~= 0 then
    vim.notify('failed to push to ' .. remote, vim.log.levels.ERROR)
    return
  end

  select_base_branch(default_branch, function(base)
    local pr_url = 'https://github.com/'
      .. origin_owner
      .. '/'
      .. origin_repo
      .. '/compare/'
      .. base
      .. '...'

    if remote ~= 'origin' then
      local remote_url_result = vim
        .system({
          'git',
          'remote',
          'get-url',
          remote,
        }, { text = true })
        :wait()

      if remote_url_result.code == 0 then
        local fork_owner = parse_github_url(remote_url_result.stdout)
        if fork_owner then
          pr_url = pr_url .. fork_owner .. ':' .. current_branch
        else
          pr_url = pr_url .. current_branch
        end
      else
        pr_url = pr_url .. current_branch
      end
    else
      pr_url = pr_url .. current_branch
    end

    vim.schedule(function()
      vim.notify('opening PR creation page...', vim.log.levels.INFO)
      vim.cmd 'redraw'
    end)
    open_browser(pr_url)
  end)
end

return M
