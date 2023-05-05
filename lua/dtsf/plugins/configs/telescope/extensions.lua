local M = {}

M.extensions = {
  fzf = {
    fuzzy = true,
    override_generic_sorter = true,
    override_file_sorter = true,
    case_mode = 'smart_case',
  },
}

return M