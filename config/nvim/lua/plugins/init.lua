return {
    { "stevearc/conform.nvim", event = { "BufWritePre" }, opts = require "configs.conform" },

    { "nvim-telescope/telescope.nvim", opts = require "configs.telescope" },

    { "nvim-treesitter/nvim-treesitter", event = { "BufReadPost", "BufNewFile" }, opts = require "configs.treesitter" },

    { "lewis6991/gitsigns.nvim", event = "User FilePost", opts = require "configs.gitsigns" },

    { import = "nvchad.blink.lazyspec" },

    { "Saghen/blink.cmp", opts = require "configs.blink"},

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

    { "nvim-tree/nvim-tree.lua", enabled = false },
    ----------------------------------- other -------------------------------------------------------------

    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        config = function()
            require("trouble").setup()
        end,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = { "Neotree" },
        branch = "v3.x",
        config = function()
            require "configs.neo-tree"
        end,
    },

    { "karb94/neoscroll.nvim", event = { "BufReadPre", "BufNewFile" }, opts = require "configs.neoscroll" },

    { "otavioschwanck/arrow.nvim", opts = require "configs.arrow" }, -- mark

    { "Bekaboo/dropbar.nvim" }, -- bar

    -- { "zbirenbaum/copilot.lua", cmd = "Copilot", event = "InsertEnter", opts = require "configs.copilot" },
    --
    -- {
    --     "zbirenbaum/copilot-cmp",
    --     config = function()
    --         require("copilot_cmp").setup()
    --     end,
    -- },

    { "olimorris/persisted.nvim", opts = require "configs.persisted" }, -- open project

    { "rmagatti/goto-preview", event = "BufReadPre", opts = require "configs.goto-preview" }, -- preview

    -- { "Exafunction/codeium.vim", event = "BufEnter" },

    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
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
