-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
	cmp = {
        icons = true,
        lspkind_text = true,
        style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    },
	nvdash = {
		load_on_startup = true,
        header = {
          "           ▄ ▄                   ",
          "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
          "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
          "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
          "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
          "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
          "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
          "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
          "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
        },

        buttons = {
          { "  Recent Project", "Spc f p", "Telescope neovim-project history" },
          { "  Find Project", "Spc f p", "Telescope neovim-project discover" },
          { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
          { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
          { "  Bookmarks", "Spc m a", "Telescope marks" },
          { "  Themes", "Spc t h", "Telescope themes" },
          { "  Mappings", "Spc c h", "NvCheatsheet" },
        },
	},
	statusline = {
		theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
	},

	tabufline = {
		order = { "treeOffset", "buffers", "tabs", "btns" },
	},
}

M.base46 = {
	theme = "onedark",
	transparency = true,
	theme_toggle = { "onedark", "penumbra_dark" },
	hl_override = {
		CursorLine = {
			bg = "black2",
		},
	},
}

return M
