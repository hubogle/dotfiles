local opts = require("nvchad.configs.telescope")
local actions = require("telescope.actions")

opts.defaults.file_ignore_patterns = { "%.git/" }

opts.defaults.mappings.i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    -- ["<Esc>"] = actions.close,
}

require("telescope").setup(opts)
