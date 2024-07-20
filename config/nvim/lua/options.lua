require("nvchad.options")

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

o.relativenumber = true -- 相对坐标

-- Indenting
o.expandtab = false -- 将制表符（Tab）转换为空格
o.shiftwidth = 4 -- 自动缩进时使用的空格数量
o.smartindent = true -- 智能缩进
o.tabstop = 4 -- 设置 Tab 字符的宽度为 4 个空格
o.softtabstop = 4 -- 设置软 Tab 的宽度为 4 个空格

o.ignorecase = true -- 搜索时忽略大小写
o.smartcase = true -- 启用智能大小写匹配
o.signcolumn = "yes" -- 始终显示标志列
o.splitbelow = true -- 设置新分屏在当前窗口的下方
o.splitright = true -- 设置新分屏在当前窗口的右侧

o.cursorlineopt = "both" -- 光标线突出显示

-- setting
o.encoding = "utf-8"
