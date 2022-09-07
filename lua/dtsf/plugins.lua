local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- packer
  use 'wbthomason/packer.nvim'

  -- luasnip
  use 'L3MON4D3/LuaSnip'

  -- plenary
  use 'nvim-lua/plenary.nvim'

  -- lsp section
  use 'neovim/nvim-lspconfig'
  use 'glepnir/lspsaga.nvim'
  use 'onsails/lspkind-nvim'

  -- mason section
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  -- treesitter section
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/nvim-treesitter-context'

  -- telescope section
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'

  -- utils section
  use 'folke/zen-mode.nvim'
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- git section
  use 'akinsho/nvim-bufferline.lua'
  use 'lewis6991/gitsigns.nvim'
  use 'dinhhuy258/git.nvim'

  -- code tools section
  use 'nvim-lualine/lualine.nvim'
  use 'MunifTanjim/prettier.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'norcalli/nvim-colorizer.lua'
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use 'github/copilot.vim'

  -- colorschemes section
  -- use { "ellisonleao/gruvbox.nvim" }
  -- use "rebelot/kanagawa.nvim"
  use ({ 'projekt0n/github-nvim-theme' })

  if packer_bootstrap then
    require('packer').sync()
  end
end)
