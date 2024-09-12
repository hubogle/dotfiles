require("nvchad.mappings")

-- add yours here
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<C-b>p", "<cmd> Telescope buffers <cr>", { desc = "Open buffers opened files" })
map("n", "<leader>fn", "<cmd> Telescope notify <cr>", { desc = "find notify" })
map("n", "<leader>fp", "<cmd> Telescope neovim-project discover <cr>", { desc = "Find project" })
map("n", "<leader>fr", "<cmd> Telescope neovim-project history <cr>", { desc = "Recent project" })

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

-- 设置可视模式下的 y 键映射
vim.keymap.set("v", "y", function()
	vim.cmd("normal! y")
	local content = vim.fn.getreg('"')
	-- 使用 echo 命令传递内容到 tmux load-buffer
	vim.fn.system("echo -n " .. vim.fn.shellescape(content) .. " | tmux load-buffer -")
end, { noremap = true, silent = true })

-- esc 退出 terminal
-- map("t", "<ESC>", function()
-- 	local win = vim.api.nvim_get_current_win()
-- 	vim.api.nvim_win_close(win, true)
-- end, { desc = "terminal close term in terminal mode" })

-- 大纲展示
map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

-- 浮动 term
map({ "n", "t" }, "<A-i>", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal Toggle Floating term" })
