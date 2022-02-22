local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
    -- C, C++
    -- formatting.clang_format,
    -- Python
		formatting.black.with({ extra_args = { '--fast' } }),
    -- diagnostics.flake8
    -- JS, TS, HTML, CSS, JSON, Markdown
		formatting.prettier.with({
      prefer_local = 'node_modules/.bin',
      -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" }
    }),
    -- JS, TS
    diagnostics.eslint.with({
      prefer_local = 'node_modules/.bin',
    }),
    -- Lua
		formatting.stylua,
	},
})
