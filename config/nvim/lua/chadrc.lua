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

	telescope = { style = "borderless" }, -- borderless / bordered

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
			{ "  Recent Project", "Spc f p", "Telescope neovim-project history" },
			{ "  Find Project", "Spc f p", "Telescope neovim-project discover" },
			{ "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
			{ "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
			{ "  Bookmarks", "Spc m a", "Telescope marks" },
			{ "  Themes", "Spc t h", "Telescope themes" },
			{ "  Mappings", "Spc c h", "NvCheatsheet" },
		},
	},

	statusline = {
		order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "codeium", "diagnostics", "lsp", "cursor", "cwd" },
		theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
		separator_style = "default",
		modules = {
			cursor = function()
				return "%#StText# %l:%c "
			end,

			codeium = function()
				return "%3{codeium#GetStatusString()}"
				-- return vim.fn["codeium#GetStatusString"]()
			end,
		},
	},

	tabufline = {
		enabled = true,
		lazyload = true,
		order = { "treeOffset", "buffers", "tabs", "btns" },
		modules = {
			btns = function()
				local btn = require("nvchad.tabufline.utils").btn
				local g = vim.g
				local toggle_theme = btn(g.toggle_theme_icon, "ThemeToggleBtn", "Toggle_theme")
				return toggle_theme
			end,
		},
	},

	lsp = {
		signature = true,
		semantic_tokens = true,
	},
}

M.base46 = {
	theme = "tokyodark",
	transparency = true,
	theme_toggle = { "onenord_light", "tokyodark" },
	hl_override = {
		CursorLine = {
			bg = { "statusline_bg", 10 },
		},
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
