dofile(vim.g.base46_cache .. "nvimtree")

local function my_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings

    -- open nvchad menu
    vim.keymap.set("n", "<C-t>", function()
        require("menu").open("nvimtree", { border = false })
    end, opts "Open Custom Menu")
end

return {
    filters = { dotfiles = false },
    disable_netrw = true,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = false,
    },
    view = {
        width = 30,
        preserve_window_proportions = true,
    },
    renderer = {
        root_folder_label = false,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
            glyphs = {
                default = "󰈚",
                folder = {
                    default = "",
                    empty = "",
                    empty_open = "",
                    open = "",
                    symlink = "",
                },
                git = { unmerged = "" },
            },
        },
    },
    on_attach = my_on_attach,
}
