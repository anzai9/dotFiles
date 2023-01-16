-- automatcially install and set up packer.nvim
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {'neoclide/coc.nvim', branch = 'release'}

  use {'lewis6991/impatient.nvim'}

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-node-modules.nvim',
    }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- cmd autocomplete
  use 'gelguy/wilder.nvim'

  -- show key bindings hint
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- file explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
  }

  -- statusline
  use {
    'nvim-lualine/lualine.nvim',
     requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }

  -- buffer line
  use {'akinsho/bufferline.nvim', tag = 'v2.*', requires = 'kyazdani42/nvim-web-devicons'}

  -- git integration
  use {
    'TimUntersberger/neogit',
    requires = {
      'nvim-lua/plenary.nvim',
    }
  }
  use {
    'lewis6991/gitsigns.nvim'
  }
  use 'sindrets/diffview.nvim'
  use {
    'akinsho/git-conflict.nvim',
    config = function()
      require('git-conflict').setup()
    end,
  }

  use 'ThePrimeagen/harpoon'
  use 'ThePrimeagen/git-worktree.nvim'

  -- indent
  use 'lukas-reineke/indent-blankline.nvim'

  -- Plugin to manipulate character pairs quickly
  use {'machakann/vim-sandwich', event = 'VimEnter'}

  -- Escape insert mode more efficiently
  use {'max397574/better-escape.nvim'}

  -- replace copy actions by delete using m to replace d
  use 'tpope/vim-repeat'
  use 'svermeulen/vim-easyclip'

  -- easymotion
  use {
    'phaazon/hop.nvim',
    branch = 'v2',
  }
  use {
    'easymotion/vim-easymotion',
  }

  -- comment tool
  use 'preservim/nerdcommenter'

  -- undo
  use 'mbbill/undotree'

  use 'terryma/vim-multiple-cursors'

  -- better syntax highlight
  use("nvim-treesitter/nvim-treesitter", {run = "TSUpdate"})

  -- theme
  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
  }
  use {"norcalli/nvim-colorizer.lua"}
  -- Colorscheme section
  use("gruvbox-community/gruvbox")
  use("folke/tokyonight.nvim")

  use {"windwp/nvim-autopairs"}
  use {"windwp/nvim-ts-autotag"}

  -- spell checker
  use {"lewis6991/spellsitter.nvim"}

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
