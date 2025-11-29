local default_settings = {
  theme = 'catppuccin-frappe',
}

local M = {
  _settings = nil,
}

local function decode_env_settings()
  local raw = vim.env.DATSNVIM_SETTINGS
  if not raw or raw == '' then
    return {}
  end
  local ok, decoded = pcall(vim.json.decode, raw)
  if ok and type(decoded) == 'table' then
    return decoded
  end
  return {}
end

local function decode_settings_file(path)
  if not path or path == '' then
    return {}
  end
  local content = vim.fn.filereadable(path) == 1 and vim.fn.readfile(path)
  if not content or vim.tbl_isempty(content) then
    return {}
  end
  local ok, decoded = pcall(vim.json.decode, table.concat(content, '\n'))
  if ok and type(decoded) == 'table' then
    return decoded
  end
  return {}
end

local function normalize_theme(theme)
  if type(theme) ~= 'string' then
    return nil
  end
  local trimmed = vim.trim(theme)
  if trimmed == '' then
    return nil
  end
  return trimmed
end

local function resolve_settings()
  local env_settings = decode_env_settings()
  local file_settings = decode_settings_file(vim.env.DATSNVIM_SETTINGS_FILE)
  local global_settings = vim.g.datsnvim_settings or {}

  local merged = vim.tbl_deep_extend(
    'force',
    {},
    default_settings,
    file_settings,
    env_settings,
    global_settings
  )

  merged.theme = normalize_theme(merged.theme) or default_settings.theme
  return merged
end

function M.get()
  if M._settings then
    return M._settings
  end

  M._settings = resolve_settings()
  vim.g.datsnvim_settings = M._settings
  return M._settings
end

function M.refresh()
  M._settings = nil
  return M.get()
end

return M
