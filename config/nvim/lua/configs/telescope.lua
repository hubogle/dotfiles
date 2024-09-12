local opts = require("nvchad.configs.telescope")
local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open

opts.defaults.file_ignore_patterns = { "%.git/" }

opts.defaults.mappings.i = {
	["<C-j>"] = actions.move_selection_next,
	["<C-k>"] = actions.move_selection_previous,
	["<C-t>"] = open_with_trouble,
	-- ["<Esc>"] = actions.close,
}

require("telescope").setup(opts)
