-- Quarto support configuration
-- Provides LSP features for Quarto documents (.qmd) with embedded code chunks
-- Dependencies: quarto-nvim, otter.nvim, nvim-treesitter

return {
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      debug = false,
      closePreviewOnExit = true,
      lspFeatures = {
        enabled = true,
        chunks = "curly",
        languages = { "r", "python", "julia", "bash", "html", "lua", "markdown" },
        diagnostics = {
          enabled = false,  -- Disabled for code chunks (they are often incomplete)
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = false, -- Enable if you use molten/slime/iron for code execution
        default_method = "slime",
        ft_runners = {},
        never_run = { "yaml" },
      },
    },
    -- Keybindings for Quarto commands
    keys = {
      { "<localleader>qp", ":QuartoPreview<CR>", desc = "Quarto Preview", silent = true },
      { "<localleader>qc", ":QuartoClosePreview<CR>", desc = "Close Quarto Preview", silent = true },
      { "<localleader>qh", ":QuartoHelp ", desc = "Quarto Help" },
    },
  },

  {
    "jmbuhr/otter.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lsp = {
        diagnostic_update_events = { "BufWritePost" },
        root_dir = function(_, bufnr)
          return vim.fs.root(bufnr or 0, {
            ".git",
            "_quarto.yml",
            "package.json",
          }) or vim.fn.getcwd(0)
        end,
      },
      buffers = {
        set_filetype = true,
        write_to_disk = false,
      },
    },
  },

  -- Treesitter configuration for Quarto and related languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Add parsers for Quarto-related languages
      vim.list_extend(opts.ensure_installed, {
        "markdown",
        "markdown_inline",
        "latex",  -- For math formulas
        "yaml",   -- For YAML front matter
      })
      return opts
    end,
  },

  -- Filetype detection for Quarto files
  {
    "nvim-lspconfig",
    opts = {
      -- Ensure LSP servers are available for embedded languages
      servers = {
        -- R language server (for R code chunks)
        r_language_server = {
          root_markers = { "DESCRIPTION", "NAMESPACE", ".Rbuildignore", "_quarto.yml" },
        },
        -- Python LSP is already configured by LazyVim's python extra
      },
    },
  },

  -- Auto-activate otter for Quarto files
  {
    "quarto-dev/quarto-nvim",
    event = "BufReadPre *.qmd",
    config = function()
      require("quarto").setup({
        lspFeatures = {
          enabled = true,
          languages = { "r", "python", "julia", "bash", "html", "lua", "markdown" },
          diagnostics = {
            enabled = false,
          },
        },
      })
      -- Auto-activate otter for LSP features in code chunks
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "quarto", "markdown" },
        callback = function()
          require("otter").activate()
        end,
      })
    end,
  },

}
