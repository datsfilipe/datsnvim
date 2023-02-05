local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end

local nmap = require('dtsf.keymap').nmap

local extensions = require('dtsf.telescope.extensions').extensions
local mappings = require('dtsf.telescope.maps').mappings
local builtin = require('dtsf.telescope.vars').builtin

telescope.setup {
  defaults = {
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    layout_strategy = 'flex',
    sorting_strategy = 'ascending',
    mappings = mappings,
  },
  extensions = extensions,
}

telescope.load_extension 'harpoon'
telescope.load_extension 'dap'
telescope.load_extension 'file_browser'
telescope.load_extension 'fzf'

local opts = { noremap = true, silent = true }

nmap {
  'sf',
  function()
    telescope.extensions.file_browser.file_browser {
      path = vim.fn.expand '%:p:h',
      cwd = vim.fn.expand '%:p:h',
      prompt_prefix = '   ',
    }
  end,
  opts,
}

nmap {
  ';h',
  function()
    telescope.extensions.harpoon.marks {
      prompt_prefix = '   ',
    }
  end,
  opts,
}

nmap {
  ';f',
  function()
    builtin.find_files {
      no_ignore = false,
      hidden = true,
      prompt_prefix = '   ',
    }
  end,
  opts,
}

nmap {
  ';r',
  function()
    builtin.live_grep {
      prompt_prefix = '   ',
    }
  end,
  opts,
}

nmap {
  '\\\\',
  function()
    builtin.buffers {
      prompt_prefix = '   ',
    }
  end,
  opts,
}

nmap {
  ';t',
  function()
    builtin.help_tags {
      prompt_prefix = '   ',
    }
  end,
  opts,
}

nmap {
  ';e',
  function()
    builtin.diagnostics {
      prompt_prefix = '   ',
    }
  end,
  opts,
}

nmap {
  ';k',
  function()
    builtin.keymaps {
      prompt_prefix = '   ',
    }
  end,
  opts,
}
