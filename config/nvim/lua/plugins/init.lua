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

	-- 展示标签
	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- 高亮缩进
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("configs.hlchunk")
		end,
	},

	-- git blame 提示
	{
		"f-person/git-blame.nvim",
		event = "VeryLazy",
		opts = {
			enabled = true,
			message_template = " <summary> • <date> • <author> • <<sha>>",
			date_format = "%m/%d/%y %H:%M",
			virtual_text_column = 1,
		},
	},

	-- markdown
	{
		"MeanderingProgrammer/render-markdown.nvim",
		config = function()
			require("configs.markdown")
		end,
		dependencies = { "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		ft = { "markdown", "Avante" },
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
}
