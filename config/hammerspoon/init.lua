hotkey = require "hs.hotkey"
hyperkey = { "⌘⌃⇧" }
hyper = { "⌃⌥" }
Hyper = { "⌘⌃⌥" }
keymap = { "⌃" }

-- 设置警报风格
hs.alert.defaultStyle.strokeColor = { white = 1, alpha = 0 }
hs.alert.defaultStyle.fillColor = { white = 0.05, alpha = 0.75 }
hs.alert.defaultStyle.radius = 10

local module_list = {
    -- "modules/reload",       -- 自动加载
    "modules/input", -- 切换输入法
    "modules/doubleCmd", -- 两次 Q 退出
    "modules/app", -- App 快捷键
    "modules/windows", -- 窗口管理
    "modules/moveWindows", -- 移动窗口
    -- "modules/airpods",      -- 链接 AirPods 快捷键
}
for _, v in ipairs(module_list) do
    require(v)
end

-- https://github.com/hououinkami/HammerspoonConfig
-- 左半屏幕：⌃ + ⌥ + ←
-- 维持原大小左边贴到桌面左边缘：⌃ + ⌥ + ⌘ + ◀︎
-- 最大化：⌃ + ⌥ + return
-- 全屏 / 非全屏：⌃ + ⌥ + ⌘ + return
-- 回到初始状态：⌃ + ⌥ + delete
