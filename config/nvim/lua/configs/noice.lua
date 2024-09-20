require("notify").setup({ background_colour = "#000000", render = "compact", stages = "slide", timeout = 2000 })
-- See: https://github.com/NvChad/NvChad/issues/1656
vim.notify = require("noice").notify

local filter_notify = {
	"written",
	"fewer lines",
	"line less;",
	"Already at",
	"lines yanked",
	"more line",
	"change;",
	"E486",
	"No results",
	"Nothing currently selected",
	"changes;",
	"No information available",
	"has already been sent, please wait",
	"is not supported by any of the servers",
	"hover is not supported",
	"response of request method",
	"not found:",
	"No buffers found with",
	"no client attached",
	"E21",
	"E382",
	"E553",
	"Cursor position outside buffer",
	"telescope.builtin.lsp_definitions",
	"telescope.builtin.diagnostics",
	"No signature help",
	"E42",
	"[LSP] Format",
	-- HACK: Plenary causes issues.  Look into this.
	"Invalid window id: 1001",
	-- This breaks noice.
	-- "[some_value]"
}

local function routes_config()
	local routes = {}
	for _, msg in ipairs(filter_notify) do
		local route = {
			filter = { find = msg },
			opts = { skip = true },
		}
		table.insert(routes, route)
	end
	return routes
end

local options = {
	lsp = {
		signature = {
			enabled = false,
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

	routes = routes_config(),

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
