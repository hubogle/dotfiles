local options = {
	chunk = {
		enable = true,
		use_treesitter = true,
		error_sign = true,
		style = "#00ffff",
	},
	indent = {
		enable = true,
		chars = {
			"│",
			"¦",
			"┆",
			"┊",
		},
	},
	line_num = {
		enable = false,
		use_treesitter = true,
	},
}

require("hlchunk").setup(options)