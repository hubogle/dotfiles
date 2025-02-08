require("notify").setup { background_colour = "#000000", render = "compact", stages = "slide", timeout = 2000 }
-- See: https://github.com/NvChad/NvChad/issues/1656
vim.notify = require("noice").notify

local options = {
    lsp = {
        signature = {
            enabled = true,
        },
        hover = { -- Shift + K show hover
            enabled = true,
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
    },

    routes = {
        {
            filter = {
                event = "lsp",
                any = {
                    { find = "formatting" },
                    { find = "Diagnosing" },
                    { find = "Diagnostics" },
                    { find = "diagnostics" },
                    { find = "code_action" },
                    { find = "Processing full semantic tokens" },
                    { find = "symbols" },
                    { find = "completion" },
                },
            },
            opts = { skip = true },
        },
        {
            filter = {
                any = {
                    { find = "No information available" },
                    { find = "No references found" },
                    { find = "No lines in buffer" },
                    { find = "NotSignedIn" },
                    { find = "buffers deleted" },
                },
            },
            opts = { skip = true },
        },
        {
            filter = {
                event = "notify",
                any = {
                    -- Neo-tree
                    { find = "Toggling hidden files: true" },
                    { find = "Toggling hidden files: false" },
                    { find = "Operation canceled" },
                    { find = "^No code actions available$" },

                    -- Telescope
                    { find = "Nothing currently selected" },
                    { find = "^No information available$" },
                    { find = "Highlight group" },
                    { find = "no manual entry for" },
                    { find = "not have parser for" },

                    -- ts
                    { find = "_ts_parse_query" },
                },
            },
            opts = { skip = true },
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                any = {

                    -- Edit
                    { find = "%d+ less lines" },
                    { find = "%d+ fewer lines" },
                    { find = "%d+ more lines" },
                    { find = "%d+ change;" },
                    { find = "%d+ line less;" },
                    { find = "%d+ more lines?;" },
                    { find = "%d+ fewer lines;?" },
                    { find = '".+" %d+L, %d+B' },
                    { find = "%d+ lines yanked" },
                    { find = "^Hunk %d+ of %d+$" },
                    { find = "%d+L, %d+B$" },
                    { find = "^[/?].*" }, -- Searching up/down
                    { find = "E486: Pattern not found:" }, -- Searcingh not found
                    { find = "%d+ changes?;" }, -- Undoing/redoing
                    { find = "%d+ fewer lines" }, -- Deleting multiple lines
                    { find = "%d+ more lines" }, -- Undoing deletion of multiple lines
                    { find = "%d+ lines " }, -- Performing some other verb on multiple lines
                    { find = "Already at newest change" }, -- Redoing
                    { find = '"[^"]+" %d+L, %d+B' }, -- Saving

                    -- Save
                    { find = " bytes written" },

                    -- Redo/Undo
                    { find = " changes; before #" },
                    { find = " changes; after #" },
                    { find = "1 change; before #" },
                    { find = "1 change; after #" },

                    -- Yank
                    { find = " lines yanked" },

                    -- Move lines
                    { find = " lines moved" },
                    { find = " lines indented" },

                    -- Bulk edit
                    { find = " fewer lines" },
                    { find = " more lines" },
                    { find = "1 more line" },
                    { find = "1 line less" },

                    -- General messages
                    { find = "Already at newest change" }, -- Redoing
                    { find = "Already at oldest change" },
                    { find = "E21: Cannot make changes, 'modifiable' is off" },
                },
            },
            opts = { skip = true },
        },
    },

    views = {
        cmdline_popup = {
            position = {
                row = 13,
                col = "50%",
            },
            size = {
                width = 60,
                height = "auto",
            },
        },
        popupmenu = {
            relative = "editor",
            position = {
                row = 16,
                col = "50%",
            },
            size = {
                width = 60,
                height = 10,
            },
            border = {
                style = "rounded",
                padding = { 0, 1 },
            },
            win_options = {
                winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
            },
        },
    },
}

vim.lsp.handlers["textDocument/hover"] = require("noice").hover
vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature
require("noice").setup(options)
