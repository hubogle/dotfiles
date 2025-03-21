return {

    {
        name = "Code Rename",
        cmd = vim.lsp.buf.rename,
        rtxt = "r",
    },

    {
        name = "Open Neotree",
        cmd = "Neotree reveal=true position=left",
        rtxt = "o",
    },

    {
        name = "  Git Actions",
        hl = "Exblue",
        items = {
            {
                name = "Git Stage Hunk",
                cmd = "Gitsigns stage_hunk",
                rtxt = "<leader>gs",
            },
            {
                name = "Git Undo Stage Hunk",
                cmd = "Gitsigns un_stage_hunk",
                rtxt = "<leader>gu",
            },
            {
                name = "Git Reset Hunk",
                cmd = "Gitsigns reset_hunk",
                rtxt = "<leader>gr",
            },
            {
                name = "Git Diff",
                cmd = "Gitsigns diffthis",
                rtxt = "<leader>gd",
            },
            {
                name = "Git Blame",
                cmd = "Gitsigns blame",
            },
            {
                name = "Git Blame Currend",
                cmd = "Gitsigns blame_line",
            },
            {
                name = "Git Toggle Deleted",
                cmd = "Gitsigns toggle_deleted",
                rtxt = "<leader>gv",
            },
            {
                name = "Git Next Hunk",
                cmd = "Gitsigns next_hunk",
                rtxt = "]c",
            },
            {
                name = "Git Prev Hunk",
                cmd = "Gitsigns prev_hunk",
                rtxt = "[c",
            },
        },
    },

    {
        name = "  Trouble Actions",
        hl = "Exblue",
        items = {
            {
                name = "Symbols (Trouble)",
                cmd = "Trouble symbols toggle focus=false",
                rtxt = "<leader>cs",
            },

            {
                name = "LSP Definitions / references (Trouble)",
                cmd = "Trouble lsp toggle focus=false",
                rtxt = "<leader>cl",
            },

            {
                name = "Buffer Diagnostics (Trouble)",
                cmd = "Trouble diagnostics toggle filter.buf=0",
                rtxt = "<leader>ex",
            },

            {
                name = "Location List (Trouble)",
                cmd = "Trouble loclist toggle",
                rtxt = "<leader>el",
            },
        },
    },

    {
        name = "  Lsp Actions",
        hl = "Exblue",
        items = "lsp",
    },

    {
        name = "Format Buffer",
        cmd = function()
            local ok, conform = pcall(require, "conform")

            if ok then
                conform.format { lsp_fallback = true }
            else
                vim.lsp.buf.format()
            end
        end,
        rtxt = "<leader>fm",
    },

    {
        name = "Code Actions",
        cmd = vim.lsp.buf.code_action,
        rtxt = "<leader>ca",
    },

    {
        name = "Edit Config",
        cmd = function()
            vim.cmd "tabnew"
            local conf = vim.fn.stdpath "config"
            vim.cmd("tcd " .. conf .. " | e init.lua")
        end,
        rtxt = "ed",
    },

    {
        name = "Copy Content",
        cmd = "%y+",
        rtxt = "<C-c>",
    },

    {
        name = "Delete Content",
        cmd = "%d",
        rtxt = "dc",
    },

    { name = "separator" },

    {
        name = "  Open in terminal",
        hl = "ExRed",
        cmd = function()
            local old_buf = require("menu.state").old_data.buf
            local old_bufname = vim.api.nvim_buf_get_name(old_buf)
            local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")

            local cmd = "cd " .. old_buf_dir

            -- base46_cache var is an indicator of nvui user!
            if vim.g.base46_cache then
                require("nvchad.term").new { cmd = cmd, pos = "sp" }
            else
                vim.cmd "enew"
                vim.fn.termopen { vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell }
            end
        end,
    },

    { name = "separator" },

    {
        name = "  Color Picker",
        cmd = function()
            require("minty.huefy").open()
        end,
    },
}
