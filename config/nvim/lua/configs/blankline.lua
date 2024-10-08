-- https://github.com/lukas-reineke/indent-blankline.nvim

dofile(vim.g.base46_cache .. "blankline")

local opts = {
    indent = { char = "│", highlight = "IblChar" },
    scope = { enabled = false },
}

local hooks = require "ibl.hooks"
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

require("ibl").setup(opts)
dofile(vim.g.base46_cache .. "blankline")
