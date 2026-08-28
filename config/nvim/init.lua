vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
    },

    { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
dofile(vim.g.base46_cache .. "trouble")

require "options"
require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- 定义 macism 命令的路径和输入法标识符
local macism_cmd = "/opt/homebrew/bin/im-select"
local english_input = "com.apple.keylayout.ABC"
local current_input_method = vim.fn.system(macism_cmd):gsub("\n", "")

-- 进入插入模式时的自动命令
vim.api.nvim_create_augroup("autocmd_esc", { clear = true })
autocmd("InsertEnter", {
    group = "autocmd_esc",
    pattern = "*",
    callback = function()
        if vim.wo.number then
            vim.cmd "set relativenumber"
        end
        if current_input_method ~= english_input then
            vim.fn.system(macism_cmd .. " " .. current_input_method)
        end
    end,
})

-- 离开插入模式时的自动命令
autocmd("InsertLeave", {
    group = "autocmd_esc",
    pattern = "*",
    callback = function()
        current_input_method = vim.fn.system(macism_cmd):gsub("\n", "")
        if current_input_method ~= english_input then
            vim.fn.system(macism_cmd .. " " .. english_input)
        end
        if vim.wo.number then
            vim.cmd "set norelativenumber"
        end
    end,
})

-- vim 打开项目时调整 windows name
autocmd("User", {
    pattern = "PersistedTelescopeLoadPost",
    callback = function()
        local actions_state = require "telescope.actions.state"
        local session = actions_state.get_selected_entry()
        local dir_name = session.dir_path:match "([^/]+)$" or "Unnamed"
        local window_id = vim.fn.system("tmux display-message -p '#{window_id}'"):gsub("%s+", "")
        local cmd = string.format("tmux rename-window -t %s %s", window_id, vim.fn.shellescape(dir_name))
        vim.fn.system(cmd)
        vim.cmd "stopinsert"
    end,
})

-- vim 恢复项目
autocmd("User", {
    pattern = "PersistedTelescopeLoadPre",
    callback = function()
        -- 保存当前项目：已加载过 session 就写回原文件，
        -- 新项目（persisted_loaded_session 为 nil）则按当前 cwd 新建，否则永远建不出记录
        require("persisted").save { session = vim.g.persisted_loaded_session }
        -- 同步删除所有 listed buffer，避免与 session 加载竞争
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end,
})

-- vim 退出项目
autocmd("User", {
    pattern = "PersistedSavePre",
    callback = function()
        local current_buf = vim.api.nvim_get_current_buf()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "neo-tree" then
                pcall(vim.cmd, "Neotree close")
            end
        end
        if vim.api.nvim_buf_is_valid(current_buf) then
            vim.api.nvim_set_current_buf(current_buf)
        end
    end,
})

-- vim 退出时恢复 tmux window 名称（:q / :qa 均生效）
autocmd("VimLeavePre", {
    callback = function()
        vim.fn.system "tmux rename-window zsh"
    end,
})

-- 对文件读取后和进入缓冲区时都触发, 判断文件是否可以修改
-- 判断是否在预览 .mise 文件夹下的源码，设置为只读模式
autocmd({ "BufReadPost", "BufEnter" }, {
    pattern = "*",
    callback = function()
        local path = vim.fn.expand "%:p"
        if path:match "/.mise" and not path:match "/%.mise%.toml$" then
            vim.bo.modifiable = false
            -- vim.bo.readonly = true
        else
            vim.bo.modifiable = true
            -- vim.bo.readonly = false
        end
    end,
})

-- 重新打开文件时恢复到上次编辑的光标位置
autocmd("BufReadPost", {
    pattern = "*",
    callback = function(args)
        -- session 加载期间由 session 文件自己定位，避免冲突
        if vim.g.SessionLoad == 1 then
            return
        end
        local ft = vim.bo[args.buf].filetype
        if ft == "gitcommit" or ft == "gitrebase" then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- 自动显示诊断浮动窗口
-- autocmd({ "CursorHold", "CursorMoved" }, {
--     callback = function()
--         vim.diagnostic.open_float(nil, { focus = false })
--     end,
-- })

-- dropbar plugin
vim.ui.select = require("dropbar.utils.menu").select

vim.schedule(function()
    require "mappings"
end)
