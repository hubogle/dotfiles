-- 增强的动态菜单系统
local M = {}

-- 检查是否在 Git 仓库中
local function is_git_repo()
    local result = vim.fn.system "git rev-parse --is-inside-work-tree 2>/dev/null"
    return result:match "true" ~= nil
end

-- 检查当前文件是否有 LSP 客户端
local function has_lsp_client()
    if vim.lsp.get_clients then
        -- Neovim 0.10+
        return #vim.lsp.get_clients { bufnr = 0 } > 0
    else
        -- Neovim 0.9 及更早版本
        return #vim.lsp.get_active_clients { bufnr = 0 } > 0
    end
end

-- 检查项目是否有特定配置文件
local function has_project_files()
    local cwd = vim.fn.getcwd()
    local files = { "package.json", "Cargo.toml", "go.mod", "requirements.txt", "pyproject.toml" }

    for _, file in ipairs(files) do
        if vim.fn.filereadable(cwd .. "/" .. file) == 1 then
            return true
        end
    end
    return false
end

-- 动态生成菜单
M.get_dynamic_menu = function()
    local base_menu = require "configs.menu"
    local has_lsp = has_lsp_client()
    local is_git = is_git_repo()

    -- 克隆基础菜单
    local dynamic_menu = vim.deepcopy(base_menu)

    -- 如果有 LSP 客户端，添加高级 LSP 功能
    if has_lsp then
        for i, item in ipairs(dynamic_menu) do
            if item.name and item.name:match "LSP Actions" then
                -- 扩展 LSP 菜单
                if type(item.items) == "table" then
                    table.insert(item.items, {
                        name = "󰌶 Restart LSP",
                        cmd = "LspRestart",
                        rtxt = "<leader>lr",
                    })
                    table.insert(item.items, {
                        name = "󰌷 LSP Info",
                        cmd = "LspInfo",
                        rtxt = "<leader>li",
                    })
                end
                break
            end
        end
    end

    -- 如果不在 Git 仓库中，移除 Git 相关菜单
    if not is_git then
        for i = #dynamic_menu, 1, -1 do
            local item = dynamic_menu[i]
            if item.name and item.name:match "Git Actions" then
                table.remove(dynamic_menu, i)
                break
            end
        end
    end

    return dynamic_menu
end

-- 获取智能的上下文菜单
M.get_smart_context_menu = function()
    local smart_menu = vim.deepcopy(context_menus.general)

    -- 添加通用的上下文操作
    table.insert(smart_menu, { name = "separator" })
    table.insert(smart_menu, {
        name = "󰘲 Back to Main Menu",
        cmd = function()
            require("menu").open(M.get_dynamic_menu(), { border = false })
        end,
        rtxt = "<Esc>",
    })

    return smart_menu
end

return M
