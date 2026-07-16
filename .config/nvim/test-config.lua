-- 测试配置是否正常工作
print("=== Neovim 配置测试 ===")

-- 测试基本设置
local tests = {
    { name = "行号设置", value = vim.opt.number:get(), expected = true },
    { name = "相对行号", value = vim.opt.relativenumber:get(), expected = true },
    { name = "Tab宽度", value = vim.opt.tabstop:get(), expected = 4 },
    { name = "Leader键", value = vim.g.mapleader, expected = " " },
    { name = "真彩色支持", value = vim.opt.termguicolors:get(), expected = true },
}

print("基本配置测试：")
for _, test in ipairs(tests) do
    local status = test.value == test.expected and "✓" or "✗"
    print(string.format("  %s %s: %s (期望: %s)", status, test.name, tostring(test.value), tostring(test.expected)))
end

-- 测试插件管理器
print("\n插件管理器测试：")
local lazy_ok, lazy = pcall(require, "lazy")
if lazy_ok then
    print("  ✓ lazy.nvim 加载成功")
else
    print("  ✗ lazy.nvim 加载失败: " .. tostring(lazy))
end

-- 测试关键插件
print("\n关键插件测试：")
local key_plugins = {
    "tokyonight",
    "nvim-tree",
    "lualine",
    "telescope",
    "Comment",
    "nvim-autopairs",
    "alpha",
}

for _, plugin in ipairs(key_plugins) do
    local ok, _ = pcall(require, plugin)
    if ok then
        print("  ✓ " .. plugin .. " 加载成功")
    else
        print("  ✗ " .. plugin .. " 加载失败")
    end
end

-- 测试键盘映射
print("\n键盘映射测试：")
local keymaps = {
    { mode = "n", lhs = "<leader>w", desc = "保存文件" },
    { mode = "n", lhs = "<leader>e", desc = "切换文件树" },
    { mode = "n", lhs = "<leader>ff", desc = "查找文件" },
    { mode = "n", lhs = "<leader>pl", desc = "插件管理器" },
    { mode = "i", lhs = "jj", desc = "退出插入模式" },
}

for _, km in ipairs(keymaps) do
    local mappings = vim.api.nvim_get_keymap(km.mode)
    local found = false
    for _, m in ipairs(mappings) do
        if m.lhs == km.lhs then
            found = true
            break
        end
    end
    if found then
        print("  ✓ " .. km.desc .. " (" .. km.lhs .. ")")
    else
        print("  ✗ " .. km.desc .. " (" .. km.lhs .. ") 未找到")
    end
end

-- 环境信息
print("\n环境信息：")
print("  Neovim 版本: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch)
print("  Lua 版本: " .. _VERSION)
print("  系统类型: " .. vim.loop.os_uname().sysname)
print("  架构: " .. vim.loop.os_uname().machine)
print("  Termux 环境: " .. tostring(os.getenv("TERMUX_VERSION") ~= nil))

print("\n=== 测试完成 ===")
print("如果所有测试通过，配置应该能正常工作。")
print("如果有失败的项目，请检查对应的配置部分。")