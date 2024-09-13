vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
	{
		"NvChad/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
		config = function()
			require("options")
		end,
	},

	{ import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("nvchad.autocmds")

local autocmd = vim.api.nvim_create_autocmd

-- 恢复文件打开时的光标位置
autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local line = vim.fn.line("'\"")
		if
			line > 1
			and line <= vim.fn.line("$")
			and vim.bo.filetype ~= "commit"
			and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
		then
			vim.cmd('normal! g`"')
		end
	end,
})

-- 创建自动命令组
vim.api.nvim_create_augroup("numbertoggle", { clear = true })

-- 进入插入模式时的自动命令
vim.api.nvim_create_autocmd("InsertEnter", {
	group = "numbertoggle",
	pattern = "*",
	callback = function()
		if vim.wo.number then
			vim.cmd("set relativenumber")
		end
	end,
})

-- 离开插入模式时的自动命令
vim.api.nvim_create_autocmd("InsertLeave", {
	group = "numbertoggle",
	pattern = "*",
	callback = function()
		if vim.wo.number then
			vim.cmd("set norelativenumber")
		end
	end,
})

-- 按 ESC 后切换英文输入法
vim.cmd([[ autocmd InsertLeave * :silent !/opt/homebrew/bin/im-select com.apple.keylayout.ABC]])

-- vim 打开项目时调整 windows name
vim.api.nvim_create_autocmd("DirChanged", {
	pattern = "*",
	callback = function()
		local cwd = vim.fn.getcwd()
		local dir_name = vim.fn.fnamemodify(cwd, ":t") -- 获取路径的最后一部分
		vim.fn.system("tmux rename-window " .. vim.fn.shellescape(dir_name))
	end,
})

-- vim 退出项目时调整 windows name
vim.api.nvim_create_autocmd("VimLeave", {
	pattern = "*",
	callback = function()
		vim.fn.system("tmux rename-window 'zsh'")
	end,
})

-- 最后一个窗口关闭 https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
vim.api.nvim_create_autocmd("BufEnter", {
	nested = true,
	callback = function()
		if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
			vim.cmd("quit")
		end
	end,
})

vim.schedule(function()
	require("mappings")
end)
