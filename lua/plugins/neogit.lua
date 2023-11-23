local ok, neogit = pcall(require, "neogit")
if not ok then
  return
end

neogit.setup {
  disable_signs = false,
  disable_context_highlighting = false,
  disable_commit_confirmation = false,
  signs = {
    section = { "", "" },
    item = { "", "" },
    hunk = { "", "" },
  },
  integrations = {
    diffview = true,
  },
}
