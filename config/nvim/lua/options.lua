require("nvchad.options")

-- add yours here!

local o = vim.o

-- 设置显示 tab 和空格字符
-- o.list = true
-- tab:» ,eol:↵：表示行尾符的显示方式
-- o.listchars = "tab:» ,lead: ,trail:·,space: ,extends:>,precedes:<"

-- 行号显示
o.number = true -- 显示行号
-- o.relativenumber = true -- 相对行号

-- Indenting
o.expandtab = false -- 将制表符（Tab）转换为空格
o.shiftwidth = 4 -- 自动缩进时使用的空格数量
o.smartindent = true -- 智能缩进
o.tabstop = 4 -- 设置 Tab 字符的宽度为 4 个空格
o.softtabstop = 4 -- 设置软 Tab 的宽度为 4 个空格

-- 搜索
o.ignorecase = true -- 搜索时忽略大小写
o.smartcase = true -- 启用智能大小写匹配
o.hlsearch = true -- 搜索时高亮匹配项
o.incsearch = true -- 搜索时增量高亮

-- 窗口分割
o.splitbelow = true -- 设置新分屏在当前窗口的下方
o.splitright = true -- 设置新分屏在当前窗口的右侧

-- 光标
o.cursorline = true -- 启用光标行
o.cursorlineopt = "both" -- 光标行突出显示

-- setting
o.encoding = "utf-8"
o.backup = false -- 禁用备份文件
o.writebackup = false -- 禁用写入备份文件
o.swapfile = false -- 禁用交换文件
o.undofile = true -- 启用持久撤销

o.wrap = true -- 文本自动换行
o.breakindent = true -- 自动换行的行会保持一定的缩进
o.linebreak = true -- 在单词之间而非单词中间进行换行
o.eventignore = "FocusLost" -- 当 Neovim 失去焦点时触发
o.termguicolors = true
