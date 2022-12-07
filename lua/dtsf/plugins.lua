local ok, packer = pcall(require, 'packer')
if not ok then
  print('Packer is not installed')
  return
end

-- init options
packer.init({
  auto_clean = true,
  compile_on_sync = true,
  git = { clone_timeout = 5000 },
  display = {
    working_sym = 'ﲊ',
    error_sym = '✗ ',
    done_sym = ' ',
    removed_sym = ' ',
    moved_sym = '',
  },
})

packer.startup {
  function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim' -- common utilities
    use {
      'L3MON4D3/LuaSnip',
      requires = 'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip/loaders/from_vscode').lazy_load()
      end,
    } -- snippets

    -- ui
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'kyazdani42/nvim-web-devicons'
    use "yamatsum/nvim-web-nonicons"

    -- must have telescope
    use {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim' }
    }
    use {
      'nvim-telescope/telescope-file-browser.nvim',
      requires = { 'nvim-telescope/telescope.nvim' }
    }
    -- colorschemes
    use 'ellisonleao/gruvbox.nvim'
    -- use 'folke/tokyonight.nvim'

    -- utilities
    use {
      'ThePrimeagen/harpoon',
      requires = { 'nvim-lua/plenary.nvim' }
    }
    use 'dinhhuy258/git.nvim'
    use({
      'iamcco/markdown-preview.nvim',
      run = function() vim.fn['mkdp#util#install']() end,
    })
    use 'wakatime/vim-wakatime'
    use 'lewis6991/gitsigns.nvim'

    -- treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
    }
    use 'nvim-treesitter/nvim-treesitter-context'

    -- lsp
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    use 'neovim/nvim-lspconfig'
    use 'glepnir/lspsaga.nvim'
    use 'onsails/lspkind-nvim'

    use 'jose-elias-alvarez/null-ls.nvim' -- must have null-ls

    -- cmp
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'saadparwaiz1/cmp_luasnip'

    use {
      'windwp/nvim-ts-autotag',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      after = 'nvim-treesitter'
    }
    use 'lukas-reineke/indent-blankline.nvim'
    use 'windwp/nvim-autopairs'
  end,
}

vim.api.nvim_exec(
  [[
  augroup packer_ide_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]],
  false
)
