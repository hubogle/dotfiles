vim.opt.sessionoptions:append("globals")

local options = {
	projects = { -- define project roots
		"~/Code/*",
		"~/Documents/Code/*",
	},
	last_session_on_startup = false,
	dashboard_mode = true,
}

return options
