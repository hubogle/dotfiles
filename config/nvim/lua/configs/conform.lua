-- https://github.com/stevearc/conform.nvim/blob/master/README.md

local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		go = { "gofumpt" },
		bash = { "beautysh" },
		sql = { "sqlfluff" },
		json = { "prettier" },
		["*"] = { "trim_whitespace" },
		-- css = { "prettier" },
		-- html = { "prettier" },
	},
	-- format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
	format_after_save = {
		lsp_fallback = true,
	},
}

require("conform").setup(options)
