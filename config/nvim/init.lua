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

-- conform 保存格式化文件
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- 自动切换行号模式
vim.cmd([[
	augroup numbertoggle
		autocmd!
		autocmd InsertEnter * set relativenumber
		autocmd InsertLeave * set norelativenumber
	augroup END
]])

-- 最后一个窗口退出，关闭目录树
vim.cmd([[ autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'nvimtree') | q | endif ]])

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

vim.schedule(function()
	require("mappings")
end)
