local markview = require "markview"
local checkboxes = require("markview.presets").checkboxes
local headings = require("markview.presets").headings
local horizontal = require("markview.presets").horizontal_rules

-- https://github.com/OXY2DEV/markview.nvim/wiki/Presets
vim.api.nvim_set_hl(0, "MarkviewHeadin1", { bg = "#453244", fg = "#f38ba8" })
vim.api.nvim_set_hl(0, "MarkviewHeadin1Label", { fg = "#f38ba8" })
vim.api.nvim_set_hl(0, "MarkviewHeading2", { bg = "#46393E", fg = "#fab387" })
vim.api.nvim_set_hl(0, "MarkviewHeading2Label", { fg = "#fab387" })
vim.api.nvim_set_hl(0, "MarkviewHeading3", { bg = "#464245", fg = "#f9e2af" })
vim.api.nvim_set_hl(0, "MarkviewHeading3Label", { fg = "#f9e2af" })
vim.api.nvim_set_hl(0, "MarkviewHeading4", { bg = "#374243", fg = "#a6e3a1" })
vim.api.nvim_set_hl(0, "MarkviewHeading4Label", { fg = "#a6e3a1" })
vim.api.nvim_set_hl(0, "MarkviewHeading5", { bg = "#2E3D51", fg = "#74c7ec" })
vim.api.nvim_set_hl(0, "MarkviewHeading5Label", { fg = "#74c7ec" })
vim.api.nvim_set_hl(0, "MarkviewHeading6", { bg = "#393B54", fg = "#b4befe" })
vim.api.nvim_set_hl(0, "MarkviewHeading6Label", { fg = "#b4befe" })

markview.setup {
    -- Buffer types to ignore
    buf_ignore = { "nofile" },
    -- Delay, in miliseconds
    -- to wait before a redraw occurs(after an event is triggered)
    debounce = 50,
    -- Filetypes where the plugin is enabled
    filetypes = { "markdown", "quarto", "rmd" },
    -- Highlight groups to use
    -- "dynamic" | "light" | "dark"
    -- highlight_groups = "dynamic",
    -- Modes where hybrid mode is enabled
    hybrid_modes = { "i" },
    -- Tree-sitter query injections
    injections = {},
    -- Initial plugin state,
    -- true = show preview
    -- falss = don't show preview
    initial_state = true,
    -- Max file size that is rendered entirely
    max_file_length = 1000,
    -- Modes where preview is shown
    modes = { "n", "no", "i", "c" },
    -- Lines from the cursor to draw when the
    -- file is too big
    render_distance = 100,
    -- Window configuration for split view
    split_conf = {},

    -- Rendering related configuration
    block_quotes = {},
    callbacks = {},
    -- checkboxes = {},
    checkboxes = checkboxes.nerd,
    code_blocks = {},
    escaped = {},
    footnotes = {},
    headings = headings.glow,
    horizontal_rules = horizontal.thick,
    html = {},
    inline_codes = {},
    latex = {},
    links = {},
    list_items = {
        enable = true,
        indent_size = 2,
        shift_width = 4,
    },
    tables = {},
}
