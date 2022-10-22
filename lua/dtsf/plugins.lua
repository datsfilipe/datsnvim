local status, packer = pcall(require, 'packer')

if (not status) then
  print('Packer is not installed')
  return
end

-- packer init options
packer.init({
  auto_clean = true,
  compile_on_sync = true,
  git = { clone_timeout = 6000 },
  display = {
    working_sym = 'ﲊ',
    error_sym = '✗ ',
    done_sym = ' ',
    removed_sym = ' ',
    moved_sym = '',
  },
})

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim' -- common utilities
  use 'L3MON4D3/LuaSnip' -- snippets

  -- ui plugins
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'
  -- must have telescope
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'goolord/alpha-nvim' -- greeting for neovim
  -- colorschemes
  use 'ellisonleao/gruvbox.nvim'

  -- coding utilities
  use 'ThePrimeagen/harpoon' -- harpoon by ThePrimeagen
  use 'wakatime/vim-wakatime' -- wakatime to keep coding track
  use 'lewis6991/gitsigns.nvim'
  use 'dinhhuy258/git.nvim'
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  -- lsp plugins
  use 'neovim/nvim-lspconfig'
  use 'glepnir/lspsaga.nvim'
  use 'onsails/lspkind-nvim'
  -- mason plugins
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'jose-elias-alvarez/null-ls.nvim' -- must have null-ls
  -- in order to have completions
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'github/copilot.vim' -- yep, copilot

  -- coding style
  use 'norcalli/nvim-base16.lua'
  use {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
  }
  use 'norcalli/nvim-colorizer.lua'
  -- treesitter for highlighting code
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'windwp/nvim-autopairs' -- autopairs
  use 'windwp/nvim-ts-autotag' -- for react
  use 'lukas-reineke/indent-blankline.nvim' -- indent lines

  if packer_bootstrap then
    packer.sync()
  end
end)

vim.api.nvim_exec(
  [[
  augroup packer_ide_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]],
  false
)
