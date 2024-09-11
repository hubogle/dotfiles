local options = {
	chunk = {
		enable = true,
		use_treesitter = true,
		error_sign = true,
	},
	indent = {
		enable = true,
		chars = {
			"│",
		},
		style = {
			vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
		},
	},
	line_num = {
		enable = true,
	},
}

require("hlchunk").setup(options)
