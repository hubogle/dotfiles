return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = require("configs.conform"),
	},

	{
		"nvim-telescope/telescope.nvim",
		opts = require("configs.telescope"),
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = require("configs.treesitter"),
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "User FilePost",
		opts = require("configs.gitsigns"),
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "User FilePost",
		config = function()
			require("configs.blankline")
		end,
	},

	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		config = function()
			dofile(vim.g.base46_cache .. "trouble")
			require("trouble").setup()
		end,
	},

	{
		"karb94/neoscroll.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = require("configs.neoscroll"),
	},

	{
		"otavioschwanck/arrow.nvim",
		lazy = false,
		opts = require("configs.arrow"),
	},

	-- 高亮缩进
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = require("configs.hlchunk"),
	},

	{
		"OXY2DEV/markview.nvim",
		ft = "markdown",
		config = function()
			require("configs.markview")
		end,
	},

	-- 最近项目
	{
		"coffebar/neovim-project",
		opts = require("configs.project"),
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
			{ "Shatur/neovim-session-manager" },
		},
	},

	-- 消息通知
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			require("configs.noice")
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

	-- 预览引用
	{
		"rmagatti/goto-preview",
		event = "BufEnter",
		config = function()
			require("goto-preview").setup({
				default_mappings = true,
			})
		end,
	},

	-- 代码补全
	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
	},
}
