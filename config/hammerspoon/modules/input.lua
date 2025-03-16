-- 设置App对应的输入法
local App2Ime = {
    ["org.hammerspoon.Hammerspoon"] = "English",
    ["org.alacritty"] = "English",
    ["com.apple.Terminal"] = "English",
    ["com.todesktop.230313mzl4w4u92"] = "English",
    ["com.microsoft.VSCode"] = "English",
    ["com.microsoft.VSCodeInsiders"] = "English",
    ["com.apple.Safari"] = "English",
    ["com.microsoft.edgemac"] = "English",
    ["com.google.Chrome"] = "English",
    ["com.apple.systempreferences"] = "English",
    ["com.apple.finder"] = "English",
    ["ru.keepcoder.Telegram"] = "Chinese",
    ["com.tencent.xinWeChat"] = "Chinese",
    ["com.tencent.WeWorkMac"] = "Chinese",
}

local function Chinese() -- 中文
    local flag = hs.keycodes.currentSourceID "im.rime.inputmethod.Squirrel.Hans"
    if not flag then
        hs.keycodes.currentSourceID "com.apple.inputmethod.SCIM.ITABC"
    end
end

local function English() -- 英文
    hs.keycodes.currentSourceID "com.apple.keylayout.ABC"
end

local function applicationWatcher(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated or eventType == hs.application.watcher.launched then -- 切换窗口或首次启动时
        local input = App2Ime[appObject:bundleID()]
        if input == "Chinese" then
            Chinese()
        elseif input == "English" then
            English()
        end
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
