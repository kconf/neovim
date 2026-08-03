-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.conceallevel = 0
vim.opt.spelllang = { "en", "cjk" }

vim.g.autoformat = false

if vim.env.PREFIX then
  local bin = vim.env.PREFIX .. "/bin"

  -- Termux executables
  if not vim.env.PATH:find(bin, 1, true) then
    vim.env.PATH = bin .. ":" .. vim.env.PATH
  end

  -- Treesitter compiler
  vim.env.CC = bin .. "/clang"
  vim.env.CXX = bin .. "/clang++"
end
