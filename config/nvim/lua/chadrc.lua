-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

local api = vim.api

local stbufnr = function()
    return api.nvim_win_get_buf(vim.g.statusline_winid or 0)
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

    telescope = { style = "bordered" }, -- borderless / bordered

    statusline = {
        order = {
            "mode",
            "file",
            "arrow",
            "git_branch",
            "git_changes",
            "%=",
            "lsp_msg",
            "%=",
            "diagnostics",
            "codeium",
            "lsp",
            "cwd",
        },
        theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
        separator_style = "default",
        modules = {
            git_branch = function()
                if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status then
                    return ""
                end
                local git_status = vim.b[stbufnr()].gitsigns_status_dict
                local branch_name = " " .. git_status.head
                return " %#St_gitHead#" .. branch_name .. "%#StText# "
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

            arrow = function()
                local statusline = require "arrow.statusline"
                local text_icon = statusline.text_for_statusline_with_icons()
                if text_icon ~= "" then
                    return " " .. text_icon .. " "
                end
                return ""
            end,

            codeium = function()
                return "%3{codeium#GetStatusString()} "
            end,
        },
    },

    tabufline = {
        enabled = true,
        lazyload = true,
        order = { "neoTree", "buffers", "tabs", "btns" },
        modules = {
            neoTree = function()
                for _, win in pairs(api.nvim_tabpage_list_wins(0)) do
                    if vim.bo[api.nvim_win_get_buf(win)].ft == "neo-tree" then
                        local selector_value = require("neo-tree.ui.selector").get()

                        if selector_value ~= nil then
                            vim.b[api.nvim_win_get_buf(win)].last_selector_value = selector_value
                            return selector_value
                        end

                        local last_selector_value = vim.b[api.nvim_win_get_buf(win)].last_selector_value
                        if last_selector_value ~= nil then
                            return last_selector_value
                        end
                    end
                end

                return ""
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
        { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
        { txt = "  New File", keys = "Spc n f", cmd = "lua vim.cmd('enew')" },
        { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
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
    transparency = false,
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
        DiagnosticUnderlineError = { undercurl = true, sp = "red", fg = "red" },
        DiagnosticUnderlineWarn = { undercurl = true, sp = "yellow", fg = "yellow" },
        DiagnosticUnderlineInfo = { undercurl = true, sp = "cyan", fg = "cyan" },
        DiagnosticUnderlineHint = { undercurl = true, sp = "blue", fg = "blue" },
        GitSignsCurrentLineBlame = { fg = "light_grey" },
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

local function updateBackgroundColors(transparency)
    local bg_value = transparency and "none" or "statusline_bg"
    M.base46.hl_add.St_gitAdded = { fg = "green", bg = bg_value }
    M.base46.hl_add.St_gitChanged = { fg = "yellow", bg = bg_value }
    M.base46.hl_add.St_gitRemoved = { fg = "red", bg = bg_value }
end

updateBackgroundColors(M.base46.transparency)

return M
