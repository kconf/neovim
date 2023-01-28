require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "cmake", "cpp", "java", "javascript", "python", "ruby", "lua", "rust" },
    highlight = {
        enable = true
    },
    indent = {
        enable = false
    },
    refactor = {
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "grr",
            },
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner"
            }
        }
    }
}

