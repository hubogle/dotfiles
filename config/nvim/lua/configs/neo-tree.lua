-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- local opts = require "neo-tree.defaults"
local opts = {
    sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
    },

    -- add_blank_line_at_top = true, -- Add a blank line at the top of the tree.
    auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab

    hide_root_node = true, -- Hide the root node.
    retain_hidden_root_indent = false, -- IF the root node is hidden, keep the indentation anyhow.

    source_selector = {
        winbar = false, -- toggle to show selector on winbar
        sources = {
            { source = 'filesystem', display_name = '󰉓 Files' },
            { source = 'buffers', display_name = '  󰈙 Buf' },
            { source = 'git_status', display_name = '  󰊢 Git' },
            { source = 'document_symbols', display_name = '  Sym' },
        },
        show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
        padding = { left = 1, right = 0 },
        separator = "",
        highlight_tab = "TbBufOff",
        highlight_tab_active = "TbBufOn",
        highlight_background = "TbBufOff",
        highlight_separator = "TbBufOff",
        highlight_separator_active = "TbBufOff",
    },

    window = {
        width = 33,
        mappings = {
            ["<s-Tab>"] = "prev_source",
            ["<Tab>"] = "next_source",
            ["Y"] = {
                function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    vim.fn.setreg("+", path, "c")
                end,
                desc = "Copy Path to Clipboard",
            },
            ["P"] = { "toggle_preview", config = { use_float = false } },
            ["b"] = "",
        },
    },
    filesystem = {
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
    },

    buffers = {
        show_unloaded = true, -- When working with sessions, for example, restored but unfocused buffers
    },

    document_symbols = {
        follow_cursor = false,
        client_filters = "first",
    },

    default_component_configs = {
        container = {
            enable_character_fade = true,
            width = "100%",
            right_padding = 0,
        },

        indent = {
            indent_size = 2,
            padding = 0,
        },
    },
}

require("neo-tree").setup(opts)
