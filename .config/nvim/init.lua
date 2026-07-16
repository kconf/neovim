-- 基本 Neovim 配置
-- 设置选项
vim.opt.number = true          -- 显示行号
vim.opt.relativenumber = true  -- 显示相对行号
vim.opt.tabstop = 4            -- Tab宽度为4个空格
vim.opt.shiftwidth = 4         -- 自动缩进宽度为4个空格
vim.opt.expandtab = true       -- 将Tab转换为空格
vim.opt.autoindent = true      -- 自动缩进
vim.opt.smartindent = true     -- 智能缩进
vim.opt.wrap = false           -- 不自动换行
vim.opt.ignorecase = true      -- 搜索时忽略大小写
vim.opt.smartcase = true       -- 搜索时智能大小写处理
vim.opt.hlsearch = true        -- 高亮搜索
vim.opt.incsearch = true       -- 增量搜索
vim.opt.cursorline = true      -- 高亮当前行
vim.opt.signcolumn = "yes"     -- 显示标记列
vim.opt.mouse = "a"            -- 启用鼠标支持
vim.opt.clipboard = "unnamedplus" -- 使用系统剪贴板
vim.opt.termguicolors = true   -- 启用真彩色支持
vim.opt.backup = false         -- 不创建备份文件
vim.opt.swapfile = false       -- 不创建交换文件
vim.opt.undofile = true        -- 持久化撤销历史
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- 撤销历史目录
vim.opt.scrolloff = 8          -- 光标距离顶部/底部保留8行
vim.opt.sidescrolloff = 8      -- 光标距离左侧/右侧保留8列
vim.opt.updatetime = 50        -- 更快的更新间隔
vim.opt.timeoutlen = 300       -- 映射超时时间

-- 设置颜色主题（将在 lazy.nvim 插件中配置）
-- 临时使用内置主题，直到插件加载完成
vim.cmd("colorscheme desert")  -- 临时使用desert主题

-- 自定义高亮
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })          -- 透明背景
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })     -- 浮动窗口透明背景

-- 基本键盘映射
local map = vim.keymap.set

-- 设置leader键为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 正常模式映射
map("n", "<leader>w", ":w<CR>", { desc = "保存文件" })          -- 保存文件
map("n", "<leader>q", ":q<CR>", { desc = "退出" })              -- 退出
map("n", "<leader>wq", ":wq<CR>", { desc = "保存并退出" })      -- 保存并退出
map("n", "<leader>qq", ":q!<CR>", { desc = "强制退出" })        -- 强制退出
map("n", "<leader>sv", ":source $MYVIMRC<CR>", { desc = "重新加载配置" }) -- 重新加载配置

-- 窗口导航
map("n", "<C-h>", "<C-w>h", { desc = "切换到左侧窗口" })
map("n", "<C-j>", "<C-w>j", { desc = "切换到下方窗口" })
map("n", "<C-k>", "<C-w>k", { desc = "切换到上方窗口" })
map("n", "<C-l>", "<C-w>l", { desc = "切换到右侧窗口" })

-- 标签页操作
map("n", "<leader>tn", ":tabnew<CR>", { desc = "新建标签页" })
map("n", "<leader>tc", ":tabclose<CR>", { desc = "关闭标签页" })
map("n", "<leader>th", ":tabprevious<CR>", { desc = "上一个标签页" })
map("n", "<leader>tl", ":tabnext<CR>", { desc = "下一个标签页" })

-- 插入模式映射
map("i", "jj", "<Esc>", { desc = "快速退出插入模式" })          -- jj 退出插入模式

-- 可视模式映射
map("v", "<", "<gv", { desc = "向左缩进" })                     -- 保持选中状态缩进
map("v", ">", ">gv", { desc = "向右缩进" })                     -- 保持选中状态缩进

-- 命令模式映射
map("c", "<C-a>", "<Home>", { desc = "移动到行首" })
map("c", "<C-e>", "<End>", { desc = "移动到行尾" })
map("c", "<C-p>", "<Up>", { desc = "上一条命令" })
map("c", "<C-n>", "<Down>", { desc = "下一条命令" })

-- 自动命令组
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 创建自动命令组
local mygroup = augroup("MyGroup", {})

-- 保存时自动格式化（需要安装格式化工具）
autocmd("BufWritePre", {
    group = mygroup,
    pattern = "*",
    callback = function()
        -- 这里可以添加自动格式化代码
        -- 例如：vim.lsp.buf.format()
    end,
})

-- 自动切换目录到当前文件所在目录
autocmd("BufEnter", {
    group = mygroup,
    pattern = "*",
    callback = function()
        if vim.fn.expand("%:p:h") ~= "" then
            vim.cmd("cd " .. vim.fn.expand("%:p:h"))
        end
    end,
})

-- 显示文件类型
autocmd("FileType", {
    group = mygroup,
    pattern = "*",
    callback = function()
        print("文件类型: " .. vim.bo.filetype)
    end,
})

-- lazy.nvim 插件管理器配置
-- 安装 lazy.nvim（如果尚未安装）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- 使用稳定分支
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 导入简化的插件配置（避免编译问题）
-- local plugins = require("plugins-simple")
local plugins = require("plugins")

-- 配置 lazy.nvim
require("lazy").setup(plugins, {
    ui = {
        border = "rounded",
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- 设置 lazy.nvim 相关键盘映射
map("n", "<leader>pl", ":Lazy<CR>", { desc = "打开插件管理器" })
map("n", "<leader>pu", ":Lazy update<CR>", { desc = "更新插件" })
map("n", "<leader>ps", ":Lazy sync<CR>", { desc = "同步插件" })
map("n", "<leader>pc", ":Lazy clean<CR>", { desc = "清理未使用插件" })

-- 设置文件树快捷键
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "切换文件树" })
map("n", "<leader>E", ":NvimTreeFindFile<CR>", { desc = "在文件树中定位当前文件" })

-- 按 <leader>h 在浮动窗口中显示帮助信息
map("n", "<leader>h", function()
    local help_text = {
        "",
        "  ╔══════════════════════════════════════════╗",
        "  ║          Neovim 配置帮助信息           ║",
        "  ╚══════════════════════════════════════════╝",
        "",
        "  基本配置：行号、相对行号、Tab 4空格、透明背景",
        "  插件管理器：lazy.nvim",
        "  颜色主题：tokyonight",
        "  Leader键：空格",
        "",
        "  ─── 常用快捷键 ───",
        "    <leader>w      保存文件",
        "    <leader>q      退出",
        "    <leader>wq     保存并退出",
        "    jj             退出插入模式",
        "    Ctrl+h/j/k/l   窗口导航",
        "",
        "  ─── 插件快捷键 ───",
        "    <leader>e      切换文件树",
        "    <leader>E      在文件树中定位文件",
        "    <leader>ff     查找文件",
        "    <leader>fg     实时搜索",
        "    <leader>fb     查找缓冲区",
        "    <leader>fh     查找帮助",
        "    <leader>pl     打开插件管理器",
        "    <leader>pu     更新插件",
        "    <leader>ps     同步插件",
        "    <leader>pc     清理未使用插件",
        "",
        "  ─── 已安装插件 ───",
        "    tokyonight.nvim  颜色主题",
        "    nvim-tree.lua    文件树",
        "    lualine.nvim     状态栏",
        "    nvim-cmp         自动补全",
        "    telescope.nvim   模糊查找",
        "    Comment.nvim     注释工具",
        "    nvim-autopairs   自动配对",
        "    alpha-nvim       启动屏幕",
        "",
        "  按 q 或 <Esc> 关闭此窗口",
        "",
    }
    
    local width = math.max(vim.fn.winwidth(0) - 10, 50)
    local height = #help_text + 2
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, help_text)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.max(math.floor((vim.o.lines - height) / 2) - 1, 0),
        col = math.max(math.floor((vim.o.columns - width) / 2), 0),
        style = "minimal",
        border = "rounded",
        title = " 帮助信息 ",
        title_pos = "center",
    })
    
    vim.api.nvim_win_set_option(win, "winhl", "Normal:NormalFloat,FloatBorder:FloatBorder")
    
    -- 按 q 或 <Esc> 关闭浮动窗口
    local bufopts = { buffer = buf }
    vim.keymap.set("n", "q", ":close<CR>", bufopts)
    vim.keymap.set("n", "<Esc>", ":close<CR>", bufopts)
end, { desc = "在浮动窗口中显示帮助信息" })
