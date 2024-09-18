local markview = require("markview")
local presets = require("markview.presets")

markview.setup({
	modes = { "n", "no", "i", "c" },
	hybrid_modes = { "i" },
	headings = presets.headings.glow_labels,
	list_items = {
		enable = true,
		shift_width = 2,
		indent_size = 2,
	},
})
