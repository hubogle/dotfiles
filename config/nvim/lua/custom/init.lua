-- example file i.e lua/custom/init.lua

-- load your globals, autocmds here or anything .__.

-- local autocmd = vim.api.nvim_create_autocmd

local opt = vim.opt
opt.history = 1000
opt.inccommand = "nosplit" -- 命令更改会在原位置显示，:%s/foo/bar/g
opt.backspace = { "indent", "eol,start" } -- 使退格操作以一种合理的方式进行

-- 显示设置
opt.relativenumber = true   -- 相对坐标
opt.scrolloff = 4 -- 光标上方和下方的最小行
opt.wrap = true     -- 自动换行
opt.textwidth = 120 -- 配置完字符数后，换行

-- 缩进设置
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.autoindent = true

-- 切换不可见字符
opt.list = true
opt.listchars = {
   tab = "→ ",
   eol = "¬",
   trail = "⋅",
   extends = "❯",
   precedes = "❮",
}

-- 搜索
opt.ignorecase = true -- case insensitive searching
opt.smartcase = true -- case-sensitive if expresson contains a capital letter
opt.hlsearch = true -- highlight search results
opt.incsearch = true -- set incremental search, like modern browsers
opt.lazyredraw = false -- don't redraw while executing macros
opt.magic = true -- set magic on, for regular expressions

-- https://yianwillis.github.io/vimcdoc/doc/autocmd.html

-- 从它最后离开的位置打开文件
vim.cmd([[au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])

-- 最后一个窗口退出，关闭目录树
vim.cmd([[ autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'nvimtree') | q | endif ]])

-- 按 ESC 后切换英文输入法
vim.cmd([[ autocmd InsertLeave * :silent !/opt/homebrew/bin/im-select com.apple.keylayout.ABC]])
-- https://github.com/rime/squirrel/issues/482
-- vim.cmd([[ autocmd InsertEnter * :silent !/opt/homebrew/bin/im-select im.rime.inputmethod.Squirrel.Rime]])
