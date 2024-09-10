return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("configs.conform")
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		config = function()
			require("configs.telescope")
		end,
	},

	-- formatting , linting
	{
		"stevearc/conform.nvim",
		config = function()
			require("configs.conform")
		end,
	},

	-- 语法高亮
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("configs.treesitter")
		end,
	},

	-- indent lines
	-- {
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = function()
	-- 		require("configs.blankline")
	-- 	end,
	-- },

	-- 目录树
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
	},

	-- https://github.com/kdheepak/lazygit.nvim
	-- git 功能插件
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- order to load the plugin when the command is run for the first time
	},
	-- 方法大纲
	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen" },
		config = function()
			require("configs.outline")
		end,
	},
	-- 最近项目
	{
		"coffebar/neovim-project",
		config = function()
			require("configs.project")
		end,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
			{ "Shatur/neovim-session-manager" },
		},
	},

	-- markdown
	{
		-- Make sure to set this up properly if you have lazy=true
		"MeanderingProgrammer/render-markdown.nvim",
		config = function()
			require("configs.markdown")
		end,
		dependencies = { "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		ft = { "markdown", "Avante" },
	},

	{
		"rcarriga/nvim-notify",
		lazy = false,
		config = function()
			require("notify").setup({background_colour = "#000000"})
			vim.notify = require("notify")
		end,
	},
}
