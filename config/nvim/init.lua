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
local macism_cmd = "/opt/homebrew/bin/macism"
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
        local dir_path = session.dir_path
        local dir_name = dir_path:match "([^/]+)$"
        vim.fn.system("tmux rename-window " .. vim.fn.shellescape(dir_name))
    end,
})

-- vim 恢复项目
autocmd("User", {
    pattern = "PersistedTelescopeLoadPre",
    callback = function()
        local session = vim.g.persisted_loaded_session
        if session ~= nil then
            require("persisted").save { session = session }
            vim.api.nvim_input "<ESC>:%bd!<CR>"
        end
    end,
})

-- vim 退出项目
autocmd("User", {
    pattern = "PersistedSavePre",
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "neo-tree" then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
        vim.fn.system "tmux rename-window 'zsh'"
    end,
})

-- 对文件读取后和进入缓冲区时都触发, 判断文件是否可以修改
-- 判断是否在预览 .mise 文件夹下的源码，设置为只读模式
autocmd({ "BufReadPost", "BufEnter" }, {
    pattern = "*",
    callback = function()
        local path = vim.fn.expand "%:p"
        if path:match "/.mise" then
            vim.bo.modifiable = false
            -- vim.bo.readonly = true
        else
            vim.bo.modifiable = true
            -- vim.bo.readonly = false
        end
    end,
})

-- dropbar plugin
vim.ui.select = require("dropbar.utils.menu").select

vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, max_width=80})]]

vim.schedule(function()
    require "mappings"
end)
