hotkey = require "hs.hotkey"
hyperkey = { '⌘⌃⇧' }
hyper = { '⌃⌥' }
Hyper = { '⌘⌃⌥' }
keymap = { '⌃' }

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

local function pressFn(mods, key)
    if key == nil then
        key = mods
        mods = {}
    end
    return function() hs.eventtap.keyStroke(mods, key, 1000) end
end

-- 为不同的按键绑定创建快捷方式
local hotkeys = {
    hs.hotkey.new({'ctrl'}, 'h', pressFn('left'), nil, pressFn('left')),
    hs.hotkey.new({'ctrl'}, 'j', pressFn('down'), nil, pressFn('down')),
    hs.hotkey.new({'ctrl'}, 'k', pressFn('up'), nil, pressFn('up')),
    hs.hotkey.new({'ctrl'}, 'l', pressFn('right'), nil, pressFn('right'))
}

local function enableHotkeys()
    for _, hk in ipairs(hotkeys) do
        hk:enable()
    end
end

local function disableHotkeys()
    for _, hk in ipairs(hotkeys) do
        hk:disable()
    end
end

-- 创建一个应用程序观察者
appWatcher = hs.application.watcher.new(function(appName, eventType, app)
    if appName == "Alacritty" then
        if eventType == hs.application.watcher.activated then
            disableHotkeys()
        elseif eventType == hs.application.watcher.deactivated then
            enableHotkeys()
        end
    end
end)

appWatcher:start()
