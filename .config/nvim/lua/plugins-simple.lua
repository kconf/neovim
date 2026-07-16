-- 简化的插件配置（避免 nvim-treesitter 编译问题）
return {
    -- lazy.nvim 自身
    {
        "folke/lazy.nvim",
        version = "*",
    },
    
    -- 颜色主题插件
    {
        "folke/tokyonight.nvim",
        lazy = false, -- 立即加载
        priority = 1000, -- 高优先级
        config = function()
            require("tokyonight").setup({
                style = "night", -- 主题风格: storm, night, day
                transparent = true, -- 透明背景
                styles = {
                    sidebars = "transparent",
                    floats = "transparent",
                },
            })
            vim.cmd("colorscheme tokyonight-night")
        end,
    },
    
    -- 文件树（简化配置）
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 35,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = false,
                },
            })
        end,
    },
    
    -- 状态栏
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "tokyonight",
                    component_separators = { left = '|', right = '|' },
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                },
            })
        end,
    },
    
    -- 自动补全（简化版）
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        -- 使用简单的片段展开
                        vim.snippet.expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'buffer' },
                    { name = 'path' },
                })
            })
        end,
    },
    
    -- 模糊查找
    {
        "nvim-telescope/telescope.nvim",
        tag = '0.1.6',
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = "move_selection_next",
                            ["<C-k>"] = "move_selection_previous",
                        },
                    },
                },
            })
            
            -- 设置键盘映射
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "查找文件" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "实时搜索" })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "查找缓冲区" })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "查找帮助" })
        end,
    },
    
    -- 注释插件
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },
    
    -- 自动配对括号
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    
    -- 启动屏幕
    {
        "goolord/alpha-nvim",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            
            dashboard.section.header.val = {
                "                                                     ",
                "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                "                                                     ",
            }
            
            dashboard.section.buttons.val = {
                dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
                dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
                dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
                dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
            }
            
            alpha.setup(dashboard.config)
        end,
    },
    
    -- 简单的语法高亮增强（替代 nvim-treesitter）
    {
        "nvim-treesitter/nvim-treesitter",
        enabled = false, -- 完全禁用
    },
}