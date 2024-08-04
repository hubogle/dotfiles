-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
	nvdash = {
		load_on_startup = false,
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
