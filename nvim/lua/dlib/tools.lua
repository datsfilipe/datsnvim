local bin_cache = {}

local function has_bin(bin)
  if bin_cache[bin] == nil then
    bin_cache[bin] = vim.fn.executable(bin) == 1
  end
  return bin_cache[bin]
end

local function find_root(markers, path)
  path = path or vim.api.nvim_buf_get_name(0)
  local root = vim.fs.find(markers, { path = path, upward = true, stop = vim.env.HOME })[1]
  return root and vim.fs.dirname(root) or nil
end

local formatters = {
  nix = { { bin = 'alejandra', args = { '--quiet', '-' } } },
  lua = {
    { bin = 'stylua', args = { '--stdin-filepath', '$FILENAME', '-' }, config = { 'stylua.toml', '.stylua.toml' } },
  },
  _js = {
    { bin = 'prettierd', args = { '$FILENAME' }, config = { '.prettierrc', 'package.json' } },
    { bin = 'biome', args = { 'format', '--stdin-filepath', '$FILENAME' }, config = { 'biome.json' } },
  },
}

for _, ft in ipairs { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json', 'html', 'css' } do
  formatters[ft] = formatters._js
end

local function run_formatter(bufnr)
  if vim.bo[bufnr].filetype == 'oil' then
    return false
  end

  local opts = formatters[vim.bo[bufnr].filetype]
  if not opts then
    return false
  end

  local tool, cwd, fname = nil, nil, vim.api.nvim_buf_get_name(bufnr)

  for _, candidate in ipairs(opts) do
    if has_bin(candidate.bin) then
      local root = candidate.config and find_root(candidate.config, fname)
      if not candidate.config or root then
        tool, cwd = candidate, root
        break
      end
    end
  end

  if not tool then
    return false
  end

  local cmd = { tool.bin }
  for _, arg in ipairs(tool.args) do
    table.insert(cmd, arg == '$FILENAME' and fname or arg)
  end

  local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n')
  local out = vim.system(cmd, { stdin = content, cwd = cwd or vim.fs.dirname(fname) }):wait()

  if out.code == 0 and out.stdout and #out.stdout > 0 then
    local new_lines = vim.split(out.stdout, '\n')
    if new_lines[#new_lines] == '' then
      table.remove(new_lines)
    end
    if table.concat(new_lines, '\n') ~= content then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
    end
    return true
  end
  return false
end

local HINT_SEVERITY = 4

local function run_cspell(bufnr)
  if not has_bin 'cspell' or vim.bo[bufnr].filetype == 'oil' then
    return
  end
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == '' then
    return
  end

  local ignored, vsc_root = {}, find_root({ '.vscode' }, fname)
  if vsc_root then
    local f = io.open(vsc_root .. '/.vscode/settings.json', 'r')
    if f then
      for w in f:read('*a'):gmatch '"c[sS]pell.words"%s*:%s*%[([^%]]+)%]' do
        for word in w:gmatch '"([^"]+)"' do
          ignored[word:lower()] = true
        end
      end
      f:close()
    end
  end

  vim.system(
    { 'cspell', 'lint', '--no-summary', '--language-id', vim.bo[bufnr].filetype, fname },
    { cwd = vim.fs.dirname(fname) },
    function(out)
      local diags = {}
      if out.stdout then
        for line in out.stdout:gmatch '[^\r\n]+' do
          local lnum, col, msg = line:match ':(%d+):(%d+)%s%-%s(.*)'
          if lnum then
            local word = msg:match '%(([^%)]+)%)'
            if not (word and ignored[word:lower()]) then
              table.insert(diags, {
                bufnr = bufnr,
                lnum = tonumber(lnum) - 1,
                col = tonumber(col) - 1,
                message = msg,
                severity = HINT_SEVERITY,
                source = 'cspell',
              })
            end
          end
        end
      end
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          pcall(function()
            local ns = vim.api.nvim_create_namespace 'user_cspell'
            vim.diagnostic.set(ns, bufnr, diags)
          end)
        end
      end)
    end
  )
end

local tools_group = vim.api.nvim_create_augroup('ToolsChain', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = tools_group,
  callback = function(ev)
    if not run_formatter(ev.buf) then
      vim.lsp.buf.format { bufnr = ev.buf, async = false }
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
  group = tools_group,
  callback = function(ev)
    run_cspell(ev.buf)
  end,
})
