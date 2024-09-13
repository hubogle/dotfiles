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

	{
		"lewis6991/gitsigns.nvim",
		event = "User FilePost",
		config = function()
			require("configs.gitsigns")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("configs.treesitter")
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

	{
		"MeanderingProgrammer/render-markdown.nvim",
		config = function()
			require("configs.markdown")
		end,
		dependencies = { "echasnovski/mini.nvim" },
		ft = { "markdown", "Avante" },
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

	-- 代码补全
	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		config = function()
			vim.keymap.set("i", "<c-a>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<c-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<c-n>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<c-p>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true, silent = true })
		end,
	},
}
