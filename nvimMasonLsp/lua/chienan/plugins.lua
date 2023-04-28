-- automatcially install and set up packer.nvim
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    Packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
    vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },             -- Required
            { 'hrsh7th/cmp-nvim-lsp' },         -- Required
            { 'L3MON4D3/LuaSnip' },             -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional

            -- SchemaStore
            { 'b0o/SchemaStore.nvim' } -- Optional
        }
    }

    use 'nvim-tree/nvim-web-devicons'

    use { 'lewis6991/impatient.nvim' }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-node-modules.nvim',
        }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- cmd autocomplete
    use 'gelguy/wilder.nvim'

    -- show key bindings hint
    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup {}
        end
    }

    -- bottom statusline
    use { 'akinsho/bufferline.nvim', tag = '*', requires = 'nvim-tree/nvim-web-devicons' }

    use {
        'folke/trouble.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
    }

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
            require('git-conflict').setup({
                default_mappings = true,     -- disable buffer local mapping created by this plugin
                default_commands = true,     -- disable commands created by this plugin
                disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
                highlights = {
                    -- They must have background color, otherwise the default color will be used
                    incoming = 'DiffText',
                    current = 'DiffAdd',
                }
            })
        end,
    }
    use 'ThePrimeagen/harpoon'
    use 'ThePrimeagen/git-worktree.nvim'

    -- indent
    use 'lukas-reineke/indent-blankline.nvim'

    -- Plugin to manipulate character pairs quickly
    use { 'machakann/vim-sandwich', event = 'VimEnter' }

    -- Escape insert mode more efficiently
    use { 'max397574/better-escape.nvim' }

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
    -- use 'preservim/nerdcommenter'
    use { 'numToStr/Comment.nvim',
        requires = {
            'JoosepAlviste/nvim-ts-context-commentstring'
        }
    }
    use { 'folke/todo-comments.nvim',
        requires = "nvim-lua/plenary.nvim",
    }

    -- undo
    use 'mbbill/undotree'

    use 'terryma/vim-multiple-cursors'

    -- better syntax highlight
    use('nvim-treesitter/nvim-treesitter', { run = 'TSUpdate' })

    -- folding tool
    use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }

    -- Colorscheme section
    -- use('gruvbox-community/gruvbox')
    -- use('folke/tokyonight.nvim')
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })
    use { 'norcalli/nvim-colorizer.lua' }
    use { 'windwp/nvim-autopairs' }
    use { 'windwp/nvim-ts-autotag' }
    use { 'RRethy/vim-illuminate',
        event = { 'BufReadPost', 'BufNewFile' },
    }

    -- copilot
    use {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require('copilot').setup({
                panel = {
                    enabled = false
                },
                suggestion = {
                    enabled = false,
                }
            })
        end,
    }
    use {
        'zbirenbaum/copilot-cmp',
        after = { 'copilot.lua' },
        config = function()
            require('copilot_cmp').setup()
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if Packer_bootstrap then
        require('packer').sync()
    end
end)
