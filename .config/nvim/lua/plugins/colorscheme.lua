return {
  -- Active colorscheme - loaded at startup
  {
    "NLKNguyen/papercolor-theme",
    lazy = false,
    priority = 1000,
  },

  -- Additional colorschemes - lazy-loaded on ColorScheme command
  { "bluz71/vim-nightfly-colors", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "romainl/Apprentice", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "sainnhe/everforest", lazy = true },

  -- Configure LazyVim to load PaperColor
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin" ,
    },
  },
}
