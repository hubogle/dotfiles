-- 设置App对应的输入法
local App2Ime = {
    ['/Applications/WeChat.app'] = 'Chinese',
    ['/Applications/企业微信.app'] = 'Chinese',
    ['/Applications/Telegram.app'] = 'Chinese',
    ['/Applications/Preview.app'] = 'Chinese',
    ['/Applications/Microsoft Word.app'] = 'Chinese',
    ['/Applications/Microsoft Excel.app'] = 'Chinese',
    ['/Applications/Microsoft PowerPoint.app'] = 'Chinese',
    ['/System/Applications/Music.app'] = 'English',
    ['/System/Library/CoreServices/Finder.app'] = 'English',
    ['/Applications/Safari.app'] = 'English',
    ['/Applications/Google Chrome.app'] = 'English',
    ['/Applications/PyCharm.app'] = 'English',
    ['/Applications/DataGrip.app'] = 'English',
    ['/Applications/GoLand.app'] = 'English',
    ['/Applications/VimR.app'] = 'English',
    ['/Applications/Paw.app'] = 'English',
    ['/Applications/Utilities/Terminal.app'] = 'English',
    ['/System/Library/CoreServices/Spotlight.app'] = 'English',
    ['/Applications/Hammerspoon.app'] = 'English',
    ['/Applications/Visual Studio Code.app'] = 'English',
    ['/Applications/System Preferences.app'] = 'English',
    ['/Applications/Alacritty.app'] = 'English',
    ['/Applications/Sublime Text.app'] = 'English',
}

local function Chinese()    -- 中文
    hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Rime")
end

local function English()    -- 英文
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

local function updateFocusAppInputMethod(app)
    -- app = hs.window.frontmostWindow():application()
    local cur_input = hs.keycodes.currentSourceID()
    local app_path = app:path()
    local next_input = App2Ime[app_path]
    if cur_input == next_input then
        return
    elseif next_input == "Chinese" then
        Chinese()
    else
        English()
    end
end

local function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated or eventType == hs.application.watcher.launched) then -- 切换窗口或首次启动时
        updateFocusAppInputMethod(appObject)
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
