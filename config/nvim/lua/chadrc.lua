-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

local stbufnr = function()
    return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

M.ui = {
    cmp = {
        icons_left = true, -- only for non-atom styles!
        lspkind_text = true,
        style = "default", -- default/flat_light/flat_dark/atom/atom_colored
        format_colors = {
            tailwind = false, -- will work for css lsp too
            icon = "󱓻",
        },
    },

    telescope = { style = "borderless" }, -- borderless / bordered

    statusline = {
        order = { "mode", "file", "git_branch", "git_changes", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd" },
        theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
        separator_style = "default",
        modules = {
            git_branch = function()
                if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status then
                    return ""
                end
                local git_status = vim.b[stbufnr()].gitsigns_status_dict
                local branch_name = " " .. git_status.head
                return " %#St_gitHead#" .. branch_name .. "%#StText#"
            end,

            git_changes = function()
                if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status then
                    return ""
                end

                local git_status = vim.b[stbufnr()].gitsigns_status_dict

                local added = (git_status.added and git_status.added ~= 0)
                        and ("%#St_gitAdded#  " .. git_status.added)
                    or ""
                local changed = (git_status.changed and git_status.changed ~= 0)
                        and ("%#St_gitChanged#  " .. git_status.changed)
                    or ""
                local removed = (git_status.removed and git_status.removed ~= 0)
                        and ("%#St_gitRemoved#  " .. git_status.removed)
                    or ""
                return "" .. added .. changed .. removed
            end,
        },
    },

    tabufline = {
        enabled = true,
        lazyload = true,
        order = { "treeOffset", "buffers", "tabs" },
        modules = {
            btns = function()
                local btn = require("nvchad.tabufline.utils").btn
                local g = vim.g
                local toggle_theme = btn(g.toggle_theme_icon, "ThemeToggleBtn", "Toggle_theme")
                return toggle_theme
            end,
        },
    },
}

M.nvdash = {
    load_on_startup = true,
    header = {
        "                            ",
        "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
        "   ▄▀███▄     ▄██ █████▀    ",
        "   ██▄▀███▄   ███           ",
        "   ███  ▀███▄ ███           ",
        "   ███    ▀██ ███           ",
        "   ███      ▀ ███           ",
        "   ▀██ █████▄▀█▀▄██████▄    ",
        "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
        "                            ",
        "     Powered By  eovim    ",
        "                            ",
    },

    buttons = {
        { txt = "  Recent Project", keys = "Spc f p", cmd = "Telescope persisted" },
        { txt = "  New File", keys = "Spc n f", cmd = "lua vim.cmd('enew')" },
        { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
        { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
        { txt = "󰈭  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
        { txt = "󱥚  Themes", keys = "Spc t h", cmd = ":lua require('nvchad.themes').open()" },
        { txt = "  Mappings", keys = "Spc c h", cmd = "NvCheatsheet" },

        { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },

        {
            txt = function()
                local stats = require("lazy").stats()
                local ms = math.floor(stats.startuptime) .. " ms"
                return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
            end,
            hl = "NvDashLazy",
            no_gap = true,
        },

        { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
    },
}

M.lsp = { signature = false }

M.colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
}

M.base46 = {
    theme = "onenord",
    transparency = true,
    theme_toggle = { "onenord", "onenord_light" },
    hl_override = {
        CursorLine = {
            bg = { "line", 3 },
        },
        Visual = {
            bg = { "line", 3 },
        },
        DiffDelete = { bg = "none", fg = "grey" },
    },
    hl_add = {
        DiagnosticUnderlineError = {
            undercurl = true,
        },
        DiagnosticUnderlineWarn = {
            undercurl = true,
        },
        GitSignsCurrentLineBlame = {
            fg = "light_grey",
        },
        St_gitAdded = { fg = "green", bg = "statusline_bg" },
        St_gitChanged = { fg = "yellow", bg = "statusline_bg" },
        St_gitRemoved = { fg = "red", bg = "statusline_bg" },
        -- St_gitHead = { fg = "nord_blue", bg = "statusline_bg" },
    },
    -- https://github.com/NvChad/base46/tree/v2.5/lua/base46/integrations
    integrations = {
        "blankline",
        "cmp",
        "git",
        "lsp",
        "mason",
        "notify",
        "nvimtree",
        "statusline",
        "telescope",
        "treesitter",
        "trouble",
        "whichkey",
    },
}

return M
