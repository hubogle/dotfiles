return {
    { "stevearc/conform.nvim", event = { "BufWritePre" }, opts = require "configs.conform" },

    { "nvim-telescope/telescope.nvim", opts = require "configs.telescope" },

    { "nvim-treesitter/nvim-treesitter", event = { "BufReadPost", "BufNewFile" }, opts = require "configs.treesitter" },

    { "lewis6991/gitsigns.nvim", event = "User FilePost", opts = require "configs.gitsigns" },

    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "User FilePost",
        config = function()
            require "configs.blankline"
        end,
    },

    ----------------------------------- other -------------------------------------------------------------

    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        config = function()
            require("trouble").setup()
        end,
    },

    { "karb94/neoscroll.nvim", event = { "BufReadPre", "BufNewFile" }, opts = require "configs.neoscroll" },

    { "otavioschwanck/arrow.nvim", lazy = false, opts = require "configs.arrow" }, -- mark

    { "Bekaboo/dropbar.nvim" }, -- bar

    { "zbirenbaum/copilot.lua", cmd = "Copilot", event = "InsertEnter", opts = require "configs.copilot" },

    { "olimorris/persisted.nvim", opts = require "configs.persisted" }, -- open project

    { "rmagatti/goto-preview", event = "BufEnter", opts = require "configs.goto-preview" }, -- preview

    { "sindrets/diffview.nvim", event = { "BufReadPre", "BufNewFile" } },

    {
        "OXY2DEV/markview.nvim",
        ft = "markdown",
        config = function()
            require "configs.markview"
        end,
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        config = function()
            require "configs.noice"
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
}
