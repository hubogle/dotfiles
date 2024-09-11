local opts = require("nvchad.configs.gitsigns")

-- https://github.com/lewis6991/gitsigns.nvim

opts.current_line_blame = true
opts.current_line_blame_opts = {
	virt_text = true,
	virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
	delay = 1000,
	ignore_whitespace = false,
	virt_text_priority = 100,
	use_focus = true,
}
opts.current_line_blame_formatter = "<author>, <author_time:%R> - <summary>"

require("gitsigns").setup(opts)
