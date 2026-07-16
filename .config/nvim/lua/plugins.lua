-- lazy.nvim 插件配置
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
    
    -- 文件树
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
    
    -- 语法高亮增强（可选，如果不需要可以注释掉）
    -- 注意：在 Termux 中可能需要手动编译解析器
    -- {
    --     "nvim-treesitter/nvim-treesitter",
    --     build = false, -- 禁用自动编译
    --     config = function()
    --         require("nvim-treesitter.configs").setup({
    --             highlight = {
    --                 enable = true,
    --             },
    --             indent = {
    --                 enable = false, -- 在移动设备上禁用
    --             },
    --             ensure_installed = {}, -- 不自动安装
    --             auto_install = false,  -- 禁用自动安装
    --         })
    --     end,
    -- },
    
    -- 自动补全
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            })
        end,
    },
    
    -- LSP 配置
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- 全局诊断配置
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = false,
            })
            
            -- 全局默认 capabilities（供所有 LSP 服务器使用）
            vim.lsp.config['*'] = {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            }
            
            -- 当任何 LSP 服务器附加到缓冲区时设置键盘映射
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(args)
                    local bufnr = args.buf
                    local bufopts = { noremap = true, silent = true, buffer = bufnr }
                    
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, bufopts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
                end,
            })
            
            -- Lua LSP 配置（使用 Neovim 0.11+ 新 API）
            vim.lsp.config['lua_ls'] = vim.tbl_deep_extend(
                'force',
                vim.lsp.config['lua_ls'] or {},
                {
                    settings = {
                        Lua = {
                            runtime = {
                                version = 'LuaJIT',
                            },
                            diagnostics = {
                                globals = {'vim'},
                            },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                                checkThirdParty = false,
                            },
                            telemetry = {
                                enable = false,
                            },
                            hint = { enable = true },
                        },
                    },
                }
            )
            
            -- 启用 Lua LSP
            vim.lsp.enable('lua_ls')
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
    
    -- Git 集成
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = '+' },
                    change       = { text = '~' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                },
            })
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
}