local markview = require "markview"

-- https://github.com/OXY2DEV/markview.nvim/wiki#%EF%B8%8F-markviewnvim
markview.setup {
    preview = {
        icon_provider = "internal", -- "mini" or "devicons"
        enable = true,
        filetypes = { "markdown", "md", "rmd", "quarto" },
        ignore_buftypes = { "nofile" },
        ignore_previews = {},

        modes = { "n", "no", "c" },
        hybrid_modes = { "i" },
        debounce = 50,
        draw_range = { vim.o.lines, vim.o.lines },
        edit_range = { 1, 0 },

        callbacks = {},

        splitview_winopts = { split = "left" },
    },
    markdown = {
        enable = true,

        block_quotes = {},
        code_blocks = {},
        headings = {},
        horizontal_rules = {},
        list_items = {},
        metadata_plus = {},
        metadata_minus = {},
        tables = {}
    },
}
