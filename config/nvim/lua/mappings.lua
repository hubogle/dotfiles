require("nvchad.mappings")

-- add yours here
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua

local map = vim.keymap.set

map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "q", function()
	require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

map("n", "<C-b>p", ":Telescope buffers<CR>", { noremap = true, silent = true, desc = "Open buffers opened files" })
map(
	"i",
	"<C-b>p",
	"<ESC>:Telescope buffers<CR>",
	{ noremap = true, silent = true, desc = "Open buffers opened files" }
)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- 跳转缓存区编号 Option + 1
-- Ctrl(Control) = C- | Alt(Option) = A-
for i = 1, 9, 1 do
	map("n", string.format("<C-%s>", i), function()
		vim.api.nvim_set_current_buf(vim.t.bufs[i])
	end)
end

-- format
map("n", "<leader>fm", function()
	require("conform").format()
end)
