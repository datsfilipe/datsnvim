local ok, formatter = pcall(require, "formatter")
if not ok then
  return
end

local util = require "formatter.util"

local find_git_ancestor = function()
  local path = util.get_current_buffer_file_path()
  local root = path
  while root ~= "/" do
    local git_dir = root .. "/.git"
    local fd = vim.loop.fs_opendir(git_dir)
    if fd then
      vim.loop.fs_closedir(fd)
      return root
    end
    root = vim.fn.fnamemodify(root, ":h")
  end
end

local prettierd = function()
  local root = find_git_ancestor()
  local possible_filenames = {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.json5",
    ".prettierrc.yaml",
    ".prettierrc.yml",
    ".prettierrc.js",
    ".prettier.config.js",
    ".prettierc.mjs",
    ".prettier.config.mjs",
    ".prettierrc.cjs",
    ".prettier.config.cjs",
  }

  for _, filename in ipairs(possible_filenames) do
    local prettier_config = root .. "/" .. filename
    local fd = vim.loop.fs_open(prettier_config, "r", 438)
    if fd then
      vim.loop.fs_close(fd)
      return {
        exe = "prettierd",
        args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
        stdin = true,
      }
    end
  end

  return nil
end

formatter.setup {
  logging = true,
  filetype = {
    typescript = {
      require("formatter.filetypes.typescript").eslint_d,
      prettierd,
    },
    typescriptreact = {
      require("formatter.filetypes.typescript").eslint_d,
      prettierd,
    },
    lua = {
      require("formatter.filetypes.lua").stylua,
    },
    rust = {
      require("formatter.filetypes.rust").rust_analyzer,
    },
  },
}

vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]],
  true
)