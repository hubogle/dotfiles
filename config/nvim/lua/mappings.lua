require("nvchad.mappings")

-- add yours here
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<C-b>p", "<cmd> Telescope buffers <cr>", { desc = "Open buffers opened files" })
map("n", "<leader>fn", "<cmd> Telescope notify <cr>", { desc = "find notify" })
map("n", "<leader>fp", "<cmd> Telescope neovim-project discover <cr>", { desc = "Find project" })
map("n", "<leader>fr", "<cmd> Telescope neovim-project history <cr>", { desc = "Recent project" })

-- trouble
map("n", "<leader>ex", "<cmd> Trouble diagnostics toggle filter.buf=0 <cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>eX", "<cmd> Trouble diagnostics toggle <cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>el", "<cmd> Trouble loclist toggle <cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>eq", "<cmd> Trouble qflist toggle <cr>", { desc = "Quickfix List (Trouble)" })

-- 显示工作区中的符号列表，如函数、变量
map("n", "<leader>cs", "<cmd> Trouble symbols toggle focus=false <cr>", { desc = "Symbols (Trouble)" })
-- 显示语言服务器协议（LSP）提供的代码定义、引用等信息
map(
	"n",
	"<leader>cl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ desc = "LSP Definitions / references / ... (Trouble)" }
)

-- 跳转缓存区编号 Option + 1
-- Ctrl(Control) = C- | Alt(Option) = A-
for i = 1, 9, 1 do
	map("n", string.format("<C-%s>", i), function()
		vim.api.nvim_set_current_buf(vim.t.bufs[i])
	end)
end

map("n", "<leader>fm", function()
	require("conform").format()
end)

-- 设置可视模式下的 y 键映射
vim.keymap.set("v", "y", function()
	vim.cmd("normal! y")
	local content = vim.fn.getreg('"')
	vim.fn.system("echo -n " .. vim.fn.shellescape(content) .. " | tmux load-buffer -")
end, { noremap = true, silent = true })

-- 浮动 term
map({ "n", "t" }, "<A-i>", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal Toggle Floating term" })

-- 仅当使用 leader + d 或者 leader + D 才与系统粘贴板交互
map("n", "<leader>d", '"+d', { noremap = true, silent = true })
map("n", "<leader>D", '"+D', { noremap = true, silent = true })
map("n", "d", '"_d', { noremap = true, silent = true })
map("n", "D", '"_D', { noremap = true, silent = true })

-- noice
map({ "n", "i", "s" }, "<c-f>", function()
	if not require("noice.lsp").scroll(4) then
		return "<c-f>"
	end
end, { silent = true, expr = true })

map({ "n", "i", "s" }, "<c-b>", function()
	if not require("noice.lsp").scroll(-4) then
		return "<c-b>"
	end
end, { silent = true, expr = true })
