-- 覆盖配置选项
local M = {}

M.treesitter = {
    ensure_installed = {
        "lua",
        "vim",
        "python",
        "go",
    },
}

M.nvimtree = {
    git = {
       enable = true,
    },
    view = {
        side = "left",
        width = 25,
        allow_resize = true,
        hide_root_folder = false, -- 显示根路径
    },
}

-- 状态栏
M.statusline = {
    style = "arrow"
}

return M
