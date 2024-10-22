-- https://github.com/stevearc/conform.nvim/blob/master/README.md

local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        python = { "isort", "black" },
        go = { "gofumpt" },
        sql = { "sqlfluff" },
        bash = { "beautysh" },
        ["*"] = { "trim_whitespace" },
        -- css = { "prettier" },
        -- html = { "prettier" },
    },

    -- format_on_save = {
    -- 	async = true, -- This isn't going to do anything. format_on_save is necessarily sync
    -- 	-- If you want async formatting, use format_after_save
    -- 	timeout_ms = 10000,
    -- 	lsp_fallback = true,
    -- },

    format_after_save = {
        lsp_format = "fallback",
    },
}

return options
