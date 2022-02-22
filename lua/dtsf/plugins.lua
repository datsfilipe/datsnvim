local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print 'Installing Packer. Wait a minute then reopen Neovim.'
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
}

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'            -- plugin manager
  use 'RRethy/nvim-base16'                -- for colorschemes

  -- Telescope
  use {'nvim-telescope/telescope.nvim', requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    }
  }

  -- use 'kyazdani42/nvim-tree.lua'          -- tree view
  use 'moll/vim-bbye'                     -- close buffers
  use 'ahmedkhalf/project.nvim'           -- manage project dirs
  use 'lewis6991/impatient.nvim'          -- increase startup time
  -- use 'folke/which-key.nvim'              -- see which keys are being used
  use 'rcarriga/nvim-notify'              -- notifications in neovim
  -- adds a truezen mode
  use {'Pocco81/TrueZen.nvim'}

  -- write enhancement
  use 'numToStr/Comment.nvim'
  use { "windwp/nvim-autopairs" }          -- add auto pairs
  use 'norcalli/nvim-colorizer.lua'        -- add colors highlight
  use {'akinsho/toggleterm.nvim'}          -- toggle terminal in neovim

  -- LSP
  use 'David-Kunz/treesitter-unit'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'tamago324/nlsp-settings.nvim'      -- language server settings defined in json for
  use 'jose-elias-alvarez/null-ls.nvim'   -- for formatters and linters

  -- auto completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      -- LSP source
      {'hrsh7th/cmp-nvim-lsp'}
    }
  }
  use "hrsh7th/cmp-buffer"                -- buffer completions
  use "hrsh7th/cmp-path"                  -- path completions
  use "hrsh7th/cmp-cmdline"               -- cmdline completions
  use "saadparwaiz1/cmp_luasnip"          -- snippet completions
  use {'tzachar/cmp-tabnine', run = './install.sh', requires = 'hrsh7th/nvim-cmp'}
  use 'rafamadriz/friendly-snippets'      -- a bunch of snippets

  use 'lewis6991/gitsigns.nvim'           -- git
  use 'editorconfig/editorconfig-vim'     --editor behavior
  -- use 'kyazdani42/nvim-web-devicons'      --icons

  -- treesitter w/for syntax highlighting
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- for react.js
  use 'windwp/nvim-ts-autotag'

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
