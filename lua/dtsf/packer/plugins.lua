local ok, packer = pcall(require, 'packer')
if not ok then
  print 'Packer is not installed'
  return
end

-- init options
packer.init {
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
}

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
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    }
    use 'kyazdani42/nvim-web-devicons'
    use 'yamatsum/nvim-web-nonicons'

    -- must have telescope
    use {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
    }
    use {
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-dap.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      requires = { 'nvim-telescope/telescope.nvim' },
    }

    -- utilities
    use {
      'ThePrimeagen/harpoon',
      requires = { 'nvim-lua/plenary.nvim' },
    }
    use 'dinhhuy258/git.nvim'
    use {
      'iamcco/markdown-preview.nvim',
      run = function()
        vim.fn['mkdp#util#install']()
      end,
    }
    use 'wakatime/vim-wakatime'
    use 'lewis6991/gitsigns.nvim'

    -- colorschemes
    use 'nyoom-engineering/oxocarbon.nvim'

    -- treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
        local ts_update = require('nvim-treesitter.install').update { with_sync = true }
        ts_update()
      end,
    }
    use {
      'nvim-treesitter/nvim-treesitter-context',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      after = 'nvim-treesitter',
    }

    -- debug adapter protocol
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'
    use 'theHamsta/nvim-dap-virtual-text'

    -- lsp
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    use 'neovim/nvim-lspconfig'
    use 'glepnir/lspsaga.nvim'
    use 'onsails/lspkind-nvim'

    use 'jose-elias-alvarez/null-ls.nvim' -- must have null-ls
    use 'numToStr/Comment.nvim' -- comments

    -- cmp
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'saadparwaiz1/cmp_luasnip'

    use {
      'zbirenbaum/copilot.lua',
      config = function()
        require('copilot').setup()
      end,
    }

    use {
      'zbirenbaum/copilot-cmp',
      after = { 'copilot.lua' },
      config = function()
        require('copilot_cmp').setup()
      end,
    }

    use {
      'windwp/nvim-ts-autotag',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      after = 'nvim-treesitter',
    }
    use 'lukas-reineke/indent-blankline.nvim'
    use 'windwp/nvim-autopairs'
    use 'norcalli/nvim-colorizer.lua'
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
