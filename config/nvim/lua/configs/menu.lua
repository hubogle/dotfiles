return {
    {
        name = "󰑕 Code Rename",
        cmd = vim.lsp.buf.rename,
        rtxt = "r",
    },

    {
        name = "󰙨 Format Buffer",
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

    -- 文件操作
    {
        name = "󰈔 File Operations",
        hl = "Exblue",
        items = {
            {
                name = "󰝰 New File",
                cmd = function()
                    local current_dir = vim.fn.expand("%:p:h")
                    local filename = vim.fn.input("New file name: ", current_dir .. "/")
                    if filename ~= "" then
                        vim.cmd("edit " .. filename)
                    end
                end,
                rtxt = "<leader>nf",
            },
            {
                name = "󰆏 Copy File Path",
                cmd = function()
                    local path = vim.fn.expand("%:p")
                    vim.fn.setreg("+", path)
                    print("Copied: " .. path)
                end,
                rtxt = "<leader>cp",
            },
            {
                name = "󰆐 Copy Relative Path",
                cmd = function()
                    local path = vim.fn.expand("%:.")
                    vim.fn.setreg("+", path)
                    print("Copied: " .. path)
                end,
                rtxt = "<leader>cr",
            },
            {
                name = "󰷈 Reveal in Finder",
                cmd = function()
                    local path = vim.fn.expand("%:p:h")
                    vim.cmd("!open " .. vim.fn.shellescape(path))
                end,
                rtxt = "<leader>rf",
            },
        },
    },

    -- Git 操作
    {
        name = "󰊢 Git Actions",
        hl = "Exblue",
        items = {
            {
                name = "󰊢 Git Status",
                cmd = "Telescope git_status",
                rtxt = "<leader>gst",
            },
            {
                name = "󰘬 Git Branches",
                cmd = "Telescope git_branches",
                rtxt = "<leader>gb",
            },
            {
                name = "󰜘 Git Commits",
                cmd = "Telescope git_commits",
                rtxt = "<leader>gc",
            },
            { name = "separator" },
            {
                name = "󰐕 Stage Hunk",
                cmd = "Gitsigns stage_hunk",
                rtxt = "<leader>gs",
            },
            {
                name = "󰣖 Undo Stage Hunk",
                cmd = "Gitsigns undo_stage_hunk",
                rtxt = "<leader>gu",
            },
            {
                name = "󰕌 Reset Hunk",
                cmd = "Gitsigns reset_hunk",
                rtxt = "<leader>gr",
            },
            {
                name = "󰍉 Git Diff",
                cmd = "Gitsigns diffthis",
                rtxt = "<leader>gd",
            },
            {
                name = "󰋚 Git Blame",
                cmd = "Gitsigns blame",
                rtxt = "<leader>gB",
            },
            {
                name = "󰋚 Git Blame Current",
                cmd = "Gitsigns blame_line",
                rtxt = "<leader>gbl",
            },
            {
                name = "󰍶 Toggle Deleted",
                cmd = "Gitsigns toggle_deleted",
                rtxt = "<leader>gv",
            },
            {
                name = "󰮰 Next Hunk",
                cmd = "Gitsigns next_hunk",
                rtxt = "]c",
            },
            {
                name = "󰮲 Prev Hunk",
                cmd = "Gitsigns prev_hunk",
                rtxt = "[c",
            },
            { name = "separator" },
            {
                name = "󰊢 LazyGit",
                cmd = "LazyGit",
                rtxt = "<leader>lg",
            },
        },
    },

    -- 诊断和调试
    {
        name = "󰔫 Trouble Actions",
        hl = "Exblue",
        items = {
            {
                name = "󰕳 Symbols (Trouble)",
                cmd = "Trouble symbols toggle focus=false",
                rtxt = "<leader>cs",
            },
            {
                name = "󰌹 LSP Definitions (Trouble)",
                cmd = "Trouble lsp toggle focus=false",
                rtxt = "<leader>cl",
            },
            {
                name = "󰅚 Buffer Diagnostics",
                cmd = "Trouble diagnostics toggle filter.buf=0",
                rtxt = "<leader>ex",
            },
            {
                name = "󰌨 Workspace Diagnostics",
                cmd = "Trouble diagnostics toggle",
                rtxt = "<leader>eX",
            },
            {
                name = "󰈚 Location List",
                cmd = "Trouble loclist toggle",
                rtxt = "<leader>el",
            },
            {
                name = "󰁨 Quickfix List",
                cmd = "Trouble qflist toggle",
                rtxt = "<leader>eq",
            },
        },
    },

    -- LSP 操作
    {
        name = "󰒋 LSP Actions",
        hl = "Exblue",
        items = "lsp",
    },

    -- 开发工具
    {
        name = "󰘦 Dev Tools",
        hl = "ExBlue",
        items = {
            {
                name = "󰅱 Code Actions",
                cmd = vim.lsp.buf.code_action,
                rtxt = "<leader>ca",
            },
            {
                name = "󰞉 Toggle Terminal",
                cmd = function()
                    require("nvchad.term").toggle({ pos = "float", id = "devTerm" })
                end,
                rtxt = "<A-t>",
            },
            {
                name = "󰧱 Floating Terminal",
                cmd = function()
                    require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
                end,
                rtxt = "<A-i>",
            },
        },
    },

    -- 项目工具
    {
        name = "󰏖 Project Tools",
        hl = "ExRed",
        items = {
            {
                name = "󰈞 Find Files",
                cmd = "Telescope find_files",
                rtxt = "<leader>ff",
            },
            {
                name = "󰈬 Live Grep",
                cmd = "Telescope live_grep",
                rtxt = "<leader>fw",
            },
            {
                name = "󰋚 Recent Projects",
                cmd = "Telescope persisted",
                rtxt = "<leader>fp",
            },
            {
                name = "󰩫 Recent Files",
                cmd = "Telescope oldfiles",
                rtxt = "<leader>fo",
            },
            {
                name = "󰔫 Project TODO",
                cmd = "Telescope live_grep search=TODO|FIXME|HACK|NOTE",
                rtxt = "<leader>td",
            },
            {
                name = "󰬬 Buffer List",
                cmd = "Telescope buffers",
                rtxt = "<leader>fb",
            },
        },
    },

    -- 编辑器设置
    {
        name = "󰒓 Editor Settings",
        hl = "ExRed",
        items = {
            {
                name = "󰢻 Edit Config",
                cmd = function()
                    vim.cmd "tabnew"
                    local conf = vim.fn.stdpath "config"
                    vim.cmd("tcd " .. conf .. " | e init.lua")
                end,
                rtxt = "ed",
            },
            {
                name = "󰚰 Reload Config",
                cmd = function()
                    vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
                    print("Config reloaded!")
                end,
                rtxt = "<leader>rc",
            },
            {
                name = "󰏘 Change Theme",
                cmd = function()
                    require("nvchad.themes").open()
                end,
                rtxt = "<leader>th",
            },
            {
                name = "󰖨 Cheatsheet",
                cmd = "NvCheatsheet",
                rtxt = "<leader>ch",
            },
            {
                name = "󰏘 Color Picker",
                cmd = function()
                    require("minty.huefy").open()
                end,
            },
        },
    },

    -- 实用工具
    {
        name = "󰋘 Copy Content",
        cmd = "%y+",
        rtxt = "<C-c>",
    },

    {
        name = "󰩺 Delete Content",
        cmd = "%d",
        rtxt = "dc",
    },

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
        rtxt = "t",
    },
}