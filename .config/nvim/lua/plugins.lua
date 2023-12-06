local ensure_packer = function()
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    })
    use 'tomtom/tcomment_vim'

    use { 'tpope/vim-dispatch', opt = true, cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = [[require('config.treesitter')]] }
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/nvim-treesitter-refactor'

    use "lukas-reineke/indent-blankline.nvim"

    -- coc
    use { 'neoclide/coc.nvim', branch = 'release', config = [[require('config.coc')]] }

    -- codeium
    use 'Exafunction/codeium.vim'

    -- copilot
    -- use 'github/copilot.vim'

    -- Search using fzf
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' }, cmd = 'Telescope',
        setup = [[require('config.telescope_setup')]] }

    -- use 'glepnir/zephyr-nvim'
    use 'sainnhe/gruvbox-material'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
