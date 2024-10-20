-- https://github.com/lukas-reineke/indent-blankline.nvim

dofile(vim.g.base46_cache .. "blankline")

local opts = {
    indent = { char = "│", tab_char = "│", highlight = "IblChar" },
    scope = {
        enabled = true,
        char = "│",
        show_start = false,
        show_end = false,
        show_exact_scope = true,
        injected_languages = true,
        highlight = { "Function", "Label" },
        priority = 500,
    },

    exclude = {
        buftypes = { "terminal" },
        filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "NvimTree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
            "lsp-installer",
        },
    },
}

local hooks = require "ibl.hooks"
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

require("ibl").setup(opts)
dofile(vim.g.base46_cache .. "blankline")
