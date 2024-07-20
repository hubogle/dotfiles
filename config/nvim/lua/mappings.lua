require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "q", function()
	require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

map("n", "<C-b>p", ":Telescope oldfiles<CR>", { noremap = true, silent = true, desc = "Open recently opened files" })
map(
	"i",
	"<C-b>p",
	"<ESC>:Telescope oldfiles<CR>",
	{ noremap = true, silent = true, desc = "Open recently opened files" }
)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- format
map("n", "<leader>fm", function()
	require("conform").format()
end)
